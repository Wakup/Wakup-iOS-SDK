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

public typealias LoadCouponMethod = (_ page: Int, _ perPage: Int, _ onComplete: @escaping (_ result: [Coupon]?, _ error: Error?) -> Void) -> Void

open class CouponCollectionHandler: NSObject, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public let layout = CHTCollectionViewWaterfallLayout()
    open weak var collectionView: UICollectionView?
    public let refreshControl = UIRefreshControl()
    
    let defaultBundle = Bundle(for: CouponCollectionHandler.self)
    lazy var loadingFooterId = "LoadingFooterView"
    lazy var loadingFooterNib: UINib = { UINib(nibName: "LoadingFooterView", bundle: self.defaultBundle) }()
    var loadingFooterView: LoadingFooterView!
    
    let couponCellId = "CouponCollectionViewCell"
    lazy var couponCellNib: UINib = { UINib(nibName: "CouponCollectionViewCell", bundle: self.defaultBundle) }()
    var prototypeCouponCell: PrototypeDataView<CouponCollectionViewCell, Coupon>!
    
    lazy var sectionHeaderId = "SectionHeaderView"
    lazy var sectionHeaderNib: UINib = { UINib(nibName: "SectionHeaderView", bundle: self.defaultBundle) }()
    
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
    
    open var showFooterWhenReloading = true
    open var reloadAnimated = true
    open var enablePagination = true
    
    open var elementsPerPage = 16
    open var pageReloadElements = 6
    
    open var userLocation: CLLocation?
    open var coupons = [Coupon]()
    open var loadCouponsMethod: LoadCouponMethod
    open var onLoadingChanged: ((_ loading: Bool) -> Void)?
    open var onContextActionSelected: OnContextMenuAction?
    open var onErrorReceived: ((_ error: Error) -> Void)?
    open var shouldLoadCoupons: ((_ page: Int) -> Bool)?
    open var lastRequestError: Error?
    open var lastRequestFailed: Bool { get { return lastRequestError != nil } }
    
    fileprivate var relatedNextPage = 0
    fileprivate var relatedHasMore = true
    open var relatedCoupons = [Coupon]()
    open var loadRelatedCouponsMethod: LoadCouponMethod?
    open var shouldLoadRelatedCoupons: ((_ page: Int) -> Bool)?
    
    
    public init(collectionView: UICollectionView?, loadCouponMethod: @escaping LoadCouponMethod) {
        self.loadCouponsMethod = loadCouponMethod
        self.collectionView = collectionView
        super.init()
        
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 6, bottom: 10, right: 6)
        layout.footerHeight = 80
        layout.headerHeight = 50
        
        prototypeCouponCell = PrototypeDataView(fromNib: couponCellNib, updateMethod: { cell, coupon in
            cell.loadImages = false
            cell.preferredWidth = self.layout.itemWidthInSection(at: 0)
            cell.userLocation = self.userLocation
            cell.coupon = coupon
        })
        
        collectionView?.register(loadingFooterNib, forSupplementaryViewOfKind: CHTCollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterId)
        collectionView?.register(sectionHeaderNib, forSupplementaryViewOfKind: CHTCollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderId)
        
        collectionView?.register(couponCellNib, forCellWithReuseIdentifier: couponCellId)
        
        collectionView?.setCollectionViewLayout(layout, animated: false)
        
        refreshControl.addTarget(self, action: #selector(CouponCollectionHandler.forceRefresh), for: UIControl.Event.valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView?.alwaysBounceVertical = true
    }
    
    open func setRelatedCouponsLoadMethod(loadMethod: @escaping LoadCouponMethod) {
        loadRelatedCouponsMethod = loadMethod
    }
    
    open func resetRelatedCouponsLoadMethod() {
        loadRelatedCouponsMethod = nil
    }
    
    @objc open func forceRefresh() {
        reloadCoupons()
        refreshControl.endRefreshing()
    }
    
    open func reloadCoupons() {
        loading = true;
        clear(cancel: false)
        loadCoupons()
    }
    
    open func loadMoreCoupons() {
        if (enablePagination && !loadingMore && !loading) {
            if (hasMore) {
                loadingMore = true;
                loadCoupons(appendResults: true)
            }
            else if (loadRelatedCouponsMethod != nil && relatedHasMore) {
                loadingMore = true;
                loadRelatedCoupons(appendResults: true)
            }
        }
    }
    
    open func cancel() {
        requestId = 0
        loading = false
        loadingMore = false
    }
    
    open func clear(cancel: Bool = true) {
        if (cancel) {
            self.cancel()
        }
        
        nextPage = 0
        hasMore = true
        coupons = [Coupon]()
        
        relatedNextPage = 0
        relatedHasMore = true
        relatedCoupons = [Coupon]()
        
        collectionView?.reloadData()
    }
    
    open func removeCoupon(_ coupon: Coupon, animated: Bool) {
        if let index = coupons.firstIndex(of: coupon) {
            removeCoupon(atIndex: index, animated: animated)
        }
    }
    
    open func removeCoupon(atIndex index: Int, animated: Bool) {
        coupons.remove(at: index)
        collectionView?.deleteItems(at: [IndexPath(row: index, section: 0)])
        if coupons.count == 0 {
            self.collectionView?.reloadEmptyDataSet()
        }
    }
    
    open func loadRelatedCoupons(appendResults append: Bool = false) {
        guard let loadMethod = loadRelatedCouponsMethod, shouldLoadRelatedCoupons?(relatedNextPage) ?? true else { return }
        
        let requestId = arc4random()
        self.requestId = requestId
        
        if (append) {
            self.loadingMore = true
        }
        else {
            self.loading = true
        }
        
        loadMethod(relatedNextPage, elementsPerPage, ({ result, error in
            self.processRequestResults(requestId: requestId, result: result, error: error, append: append, relatedSection: true)
        }))
    }
    
    open func loadCoupons(appendResults append: Bool = false) {
        guard shouldLoadCoupons?(nextPage) ?? true else { return }
        
        let requestId = arc4random()
        self.requestId = requestId
        
        if (append) {
            self.loadingMore = true
        }
        else {
            self.loading = true
        }
        
        loadCouponsMethod(nextPage, elementsPerPage, ({ result, error in
            self.processRequestResults(requestId: requestId, result: result, error: error, append: append)
        }))
    }
    
    open func processRequestResults(requestId: UInt32, result: [Coupon]?, error: Error?, append: Bool = false, relatedSection: Bool = false) {
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
            if (relatedSection) {
                self.relatedHasMore = coupons.count >= self.elementsPerPage
                self.relatedNextPage += 1
            }
            else {
                self.hasMore = coupons.count >= self.elementsPerPage
                self.nextPage += 1
            }
            
            let section = relatedSection ? 1 : 0
            if (append) {
                let existingCoupons = relatedSection ? self.relatedCoupons : self.coupons
                let indexes = existingCoupons.count ..< existingCoupons.count + coupons.count
                let indexPaths = indexes.map { index in IndexPath(row: index, section: section) }
                if (relatedSection) {
                    self.relatedCoupons += coupons
                }
                else {
                    self.coupons += coupons
                }
                self.collectionView?.insertItems(at: indexPaths)
            }
            else {
                if (relatedSection) {
                    self.relatedCoupons = coupons
                }
                else {
                    self.coupons = coupons
                }
                if (self.reloadAnimated) {
                    self.collectionView?.reloadSections(IndexSet(integer: section))
                }
                else {
                    self.collectionView?.reloadData()
                }
            }
            
            self.collectionView?.reloadEmptyDataSet()
            
            // Manually load related offers if offer list comes empty
            if (!relatedSection && self.coupons.count == 0 && loadRelatedCouponsMethod != nil) {
                self.loadRelatedCoupons(appendResults: true)
            }
        }
    }

    
    open func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let coupons = indexPath.section == 0 ? self.coupons : self.relatedCoupons
        return prototypeCouponCell.getUpdatedSize(data: coupons[(indexPath as NSIndexPath).row])
    }
    
    open func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, heightForFooterInSection section: Int) -> CGFloat {
        let lastSection = numberOfSections(in: collectionView)
        let showLoading = lastSection == section && (loadingMore || (showFooterWhenReloading && loading))
        return showLoading ? layout.footerHeight : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 && relatedCoupons.count > 0 ? layout.headerHeight : 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? coupons.count : relatedCoupons.count
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return loadRelatedCouponsMethod != nil ? 2 : 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let coupons = indexPath.section == 0 ? self.coupons : self.relatedCoupons
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
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Do nothing
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case CHTCollectionElementKindSectionFooter:
            loadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadingFooterId, for: indexPath) as? LoadingFooterView
            loadingFooterView?.isHidden = !(loadingMore || (showFooterWhenReloading && loading))
            return loadingFooterView
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderId, for: indexPath) as! SectionHeaderView
            return header
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let couponCount = (indexPath.section == 1 ? relatedCoupons : coupons).count
        if (couponCount - (indexPath as NSIndexPath).row <= pageReloadElements) {
            loadMoreCoupons()
        }
    }
}
