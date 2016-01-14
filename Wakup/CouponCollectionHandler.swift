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

typealias LoadCouponMethod = (page: Int, perPage: Int, onComplete: (result: [Coupon]?, error: ErrorType?) -> Void) -> Void

class CouponCollectionHandler: NSObject, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let layout = CHTCollectionViewWaterfallLayout()
    weak var collectionView: UICollectionView?
    let refreshControl = UIRefreshControl()
    
    let defaultBundle = NSBundle(forClass: CouponCollectionHandler.self)
    lazy var loadingFooterId = "LoadingFooterView"
    lazy var loadingFooterNib: UINib = { UINib(nibName: "LoadingFooterView", bundle: self.defaultBundle) }()
    var loadingFooterView: LoadingFooterView!
    
    let couponCellId = "CouponCollectionViewCell"
    lazy var couponCellNib: UINib = { UINib(nibName: "CouponCollectionViewCell", bundle: self.defaultBundle) }()
    var prototypeCouponCell: PrototypeDataView<CouponCollectionViewCell, Coupon>!
    
    private var requestId = arc4random()
    private var nextPage = 0
    private var hasMore = true
    var loadingMore: Bool = false {
        didSet {
            loadingFooterView?.hidden = !loadingMore
        }
    }
    
    var loading: Bool = false {
        didSet {
            if let onLoadingChanged = self.onLoadingChanged {
                onLoadingChanged(loading: self.loading)
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
    var onLoadingChanged: ((loading: Bool) -> Void)?
    var onContextActionSelected: OnContextMenuAction?
    var onErrorReceived: ((error: ErrorType) -> Void)?
    var shouldLoadCoupons: ((page: Int) -> Bool)?
    var lastRequestError: ErrorType?
    var lastRequestFailed: Bool { get { return lastRequestError != nil } }
    
    
    init(collectionView: UICollectionView?, loadCouponMethod: LoadCouponMethod) {
        self.loadCouponsMethod = loadCouponMethod
        self.collectionView = collectionView
        super.init()
        
        layout.sectionInset = UIEdgeInsetsMake(10, 6, 10, 6)
        layout.footerHeight = 80
        
        prototypeCouponCell = PrototypeDataView(fromNib: couponCellNib, updateMethod: { cell, coupon in
            cell.loadImages = false
            cell.preferredWidth = self.layout.itemWidthInSectionAtIndex(0)
            cell.userLocation = self.userLocation
            cell.coupon = coupon
        })
        
        collectionView?.registerNib(loadingFooterNib, forSupplementaryViewOfKind: CHTCollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterId)
        
        collectionView?.registerNib(couponCellNib, forCellWithReuseIdentifier: couponCellId)
        
        collectionView?.setCollectionViewLayout(layout, animated: false)
        
        refreshControl.addTarget(self, action: "forceRefresh", forControlEvents: UIControlEvents.ValueChanged)
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
    
    func removeCoupon(coupon: Coupon, animated: Bool) {
        if let index = coupons.indexOf(coupon) {
            removeCoupon(atIndex: index, animated: animated)
        }
    }
    
    func removeCoupon(atIndex index: Int, animated: Bool) {
        coupons.removeAtIndex(index)
        collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)])
        if coupons.count == 0 {
            self.collectionView?.reloadEmptyDataSet()
        }
    }
    
    func loadCoupons(appendResults append: Bool = false) {
        if shouldLoadCoupons != nil && !shouldLoadCoupons!(page: nextPage) {
            return
        }
        
        let requestId = arc4random()
        self.requestId = requestId
        
        loadCouponsMethod(page: nextPage, perPage: elementsPerPage, onComplete: ({ result, error in
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
                    self.onErrorReceived?(error: error)
                }
                else {
                    UIAlertView(title: "ConnectionErrorTitle".i18n(), message: "ConnectionErrorMsg".i18n(), delegate: nil, cancelButtonTitle: "CloseDialogButton".i18n()).show()
                }
            }
            else {
                let coupons = result ?? [Coupon]()
                self.hasMore = coupons.count >= self.elementsPerPage
                self.nextPage += 1
                
                if (append) {
                    let indexes = self.coupons.count..<self.coupons.count + coupons.count
                    let indexPaths = indexes.map { index in NSIndexPath(forRow: index, inSection: 0) }
                    self.coupons += coupons
                    self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                }
                else {
                    self.coupons = coupons
                    if (self.reloadAnimated) {
                        self.collectionView?.reloadSections(NSIndexSet(index: 0))
                    }
                    else {
                        self.collectionView?.reloadData()
                    }
                }
                self.collectionView?.reloadEmptyDataSet()
            }
        }))
    }

    
    func collectionView (collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return prototypeCouponCell.getUpdatedSize(data: coupons[indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(couponCellId, forIndexPath: indexPath) as! CouponCollectionViewCell
        cell.userLocation = userLocation
        cell.coupon = coupons[indexPath.row]
        cell.onContextMenuAction = onContextActionSelected
        
        // Workaround for 'willDisplayCell' method not existing prior to iOS 8
        if #available(iOS 8.0, *) {}
        else {
            self.collectionView(collectionView, willDisplayCell: cell, forItemAtIndexPath: indexPath)
        }
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Do nothing
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        loadingFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: loadingFooterId, forIndexPath: indexPath) as! LoadingFooterView
        loadingFooterView?.hidden = !(loadingMore || (showFooterWhenReloading && loading))
        return loadingFooterView
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if (coupons.count - indexPath.row <= pageReloadElements) {
            loadMoreCoupons()
        }
    }
}