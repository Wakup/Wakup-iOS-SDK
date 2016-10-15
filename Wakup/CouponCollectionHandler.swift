//
//  CouponCollectionHandler.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 26/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit
import CHTCollectionViewWaterfallLayout
import CoreLocation
import DZNEmptyDataSet

typealias LoadCouponMethod = (_ page: Int, _ perPage: Int, _ onComplete: (_ result: [Coupon]?, _ error: Error?) -> Void) -> Void

class CouponCollectionHandler: NSObject, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let layout = CHTCollectionViewWaterfallLayout()
    weak var collectionView: UICollectionView?
    let refreshControl = UIRefreshControl()
    
    let defaultBundle = Bundle(for: CouponCollectionHandler.self)
    lazy var loadingFooterId = "LoadingFooterView"
    lazy var loadingFooterNib: UINib = { UINib(nibName: "LoadingFooterView", bundle: self.defaultBundle) }()
    var loadingFooterView: LoadingFooterView!
    
    let couponCellId = "CouponCollectionViewCell"
    lazy var couponCellNib: UINib = { UINib(nibName: "CouponCollectionViewCell", bundle: self.defaultBundle) }()
    var prototypeCouponCell: PrototypeDataView<CouponCollectionViewCell, Coupon>!
    
    fileprivate var requestId = arc4random()
    fileprivate var nextPage = 0
    fileprivate var hasMore = true
    var loadingMore: Bool = false {
        didSet {
            loadingFooterView?.isHidden = !loadingMore
        }
    }
    
    var loading: Bool = false {
        didSet {
            if let onLoadingChanged = self.onLoadingChanged {
                onLoadingChanged(self.loading)
            }
        }
    }
    
    var showFooterWhenReloading = true
    var reloadAnimated = true
    var enablePagination = true
    
    var elementsPerPage = 16
    var pageReloadElements = 6
    
    var userLocation: CLLocation?
    var coupons = [Coupon]()
    var loadCouponsMethod: LoadCouponMethod
    var onLoadingChanged: ((_ loading: Bool) -> Void)?
    var onContextActionSelected: OnContextMenuAction?
    var onErrorReceived: ((_ error: Error) -> Void)?
    var shouldLoadCoupons: ((_ page: Int) -> Bool)?
    var lastRequestError: Error?
    var lastRequestFailed: Bool { get { return lastRequestError != nil } }
    
    
    init(collectionView: UICollectionView?, loadCouponMethod: @escaping LoadCouponMethod) {
        self.loadCouponsMethod = loadCouponMethod
        self.collectionView = collectionView
        super.init()
        
        layout.sectionInset = UIEdgeInsetsMake(10, 6, 10, 6)
        layout.footerHeight = 80
        
        prototypeCouponCell = PrototypeDataView(fromNib: couponCellNib, updateMethod: { cell, coupon in
            cell.loadImages = false
            cell.preferredWidth = self.layout.itemWidthInSection(at: 0)
            cell.userLocation = self.userLocation
            cell.coupon = coupon
        })
        
        collectionView?.register(loadingFooterNib, forSupplementaryViewOfKind: CHTCollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterId)
        
        collectionView?.register(couponCellNib, forCellWithReuseIdentifier: couponCellId)
        
        collectionView?.setCollectionViewLayout(layout, animated: false)
        
        refreshControl.addTarget(self, action: #selector(CouponCollectionHandler.forceRefresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView?.alwaysBounceVertical = true
    }
    
    func forceRefresh() {
        reloadCoupons()
        refreshControl.endRefreshing()
    }
    
    func reloadCoupons() {
        nextPage = 0
        loading = true;
        loadCoupons()
    }
    
    func loadMoreCoupons() {
        if (enablePagination && hasMore && !loadingMore && !loading) {
            loadingMore = true;
            loadCoupons(appendResults: true)
        }
    }
    
    func cancel() {
        requestId = 0
        loading = false
        loadingMore = false
    }
    
    func clear() {
        cancel()
        nextPage = 0
        coupons = [Coupon]()
        collectionView?.reloadData()
    }
    
    func removeCoupon(_ coupon: Coupon, animated: Bool) {
        if let index = coupons.index(of: coupon) {
            removeCoupon(atIndex: index, animated: animated)
        }
    }
    
    func removeCoupon(atIndex index: Int, animated: Bool) {
        coupons.remove(at: index)
        collectionView?.deleteItems(at: [IndexPath(row: index, section: 0)])
        if coupons.count == 0 {
            self.collectionView?.reloadEmptyDataSet()
        }
    }
    
    func loadCoupons(appendResults append: Bool = false) {
        if shouldLoadCoupons != nil && !shouldLoadCoupons!(nextPage) {
            return
        }
        
        let requestId = arc4random()
        self.requestId = requestId
        
        loadCouponsMethod(nextPage, elementsPerPage, ({ result, error in
            if (self.requestId != requestId) {
                NSLog("Discarding request")
                return
            }
            self.lastRequestError = error
            self.loading = false
            self.loadingMore = false
            if let error = error {
                NSLog("Received error \(error)")
                if self.onErrorReceived != nil {
                    self.onErrorReceived?(error)
                }
                else {
                    guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
                    let alert = UIAlertController(title: "ConnectionErrorTitle".i18n(), message: "ConnectionErrorMsg".i18n(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "CloseDialogButton".i18n(), style: .cancel, handler: nil))
                    rootVC.present(alert, animated: true, completion: nil)
                }
            }
            else {
                let coupons = result ?? [Coupon]()
                self.hasMore = coupons.count >= self.elementsPerPage
                self.nextPage += 1
                
                if (append) {
                    let indexes = self.coupons.count..<self.coupons.count + coupons.count
                    let indexPaths = indexes.map { index in IndexPath(row: index, section: 0) }
                    self.coupons += coupons
                    self.collectionView?.insertItems(at: indexPaths)
                }
                else {
                    self.coupons = coupons
                    if (self.reloadAnimated) {
                        self.collectionView?.reloadSections(IndexSet(integer: 0))
                    }
                    else {
                        self.collectionView?.reloadData()
                    }
                }
                self.collectionView?.reloadEmptyDataSet()
            }
        }))
    }

    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return prototypeCouponCell.getUpdatedSize(data: coupons[(indexPath as NSIndexPath).row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: couponCellId, for: indexPath) as! CouponCollectionViewCell
        cell.userLocation = userLocation
        cell.coupon = coupons[(indexPath as NSIndexPath).row]
        cell.onContextMenuAction = onContextActionSelected
        
        // Workaround for 'willDisplayCell' method not existing prior to iOS 8
        if #available(iOS 8.0, *) {}
        else {
            self.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Do nothing
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        loadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadingFooterId, for: indexPath) as! LoadingFooterView
        loadingFooterView?.isHidden = !(loadingMore || (showFooterWhenReloading && loading))
        return loadingFooterView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (coupons.count - (indexPath as NSIndexPath).row <= pageReloadElements) {
            loadMoreCoupons()
        }
    }
}
