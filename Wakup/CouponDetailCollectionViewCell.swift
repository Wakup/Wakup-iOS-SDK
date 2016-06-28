//
//  CouponDetailCollectionViewCell.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 11/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import CoreLocation

class CouponDetailCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, CouponDetailHeaderViewDelegate {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let couponHeaderId = "CouponDetailHeaderView"
    let couponHeaderNib = UINib(nibName: "CouponDetailHeaderView", bundle: CurrentBundle.currentBundle())
    var couponHeaderView: CouponDetailHeaderView!
    var prototypeHeaderView: PrototypeDataView<CouponDetailHeaderView, Coupon>!
    
    var couponCollectionHandler: CouponCollectionHandler?
    
    var coupon: Coupon! { didSet { refreshUI(); } }
    var userLocation: CLLocation? { didSet { couponCollectionHandler?.userLocation = userLocation } }
    
    var showDetailsDelegate: ((cell: CouponDetailCollectionViewCell, coupons: [Coupon], selectedIndex: Int) -> Void)?
    var showMapDelegate: ((cell: CouponDetailCollectionViewCell, coupon: Coupon) -> Void)?
    var shareDelegate: ((cell: CouponDetailCollectionViewCell, coupon: Coupon) -> Void)?
    var showDescriptionDelegate: ((cell: CouponDetailCollectionViewCell, coupon: Coupon) -> Void)?
    var showCompanyDelegate: ((cell: CouponDetailCollectionViewCell, coupon: Coupon) -> Void)?
    var showLinkDelegate: ((cell: CouponDetailCollectionViewCell, coupon: Coupon) -> Void)?
    var showRedemptionCodeDelegate: ((cell: CouponDetailCollectionViewCell, coupon: Coupon) -> Void)?
    
    var selectedIndex: NSIndexPath!
    
    let offersService = OffersService.sharedInstance
    
    func selectionChanged(couponIndex couponIndex: Int) {
        selectedIndex = NSIndexPath(forRow: couponIndex, inSection: selectedIndex?.section ?? 0)
    }
    
    override func awakeFromNib() {
        prototypeHeaderView = PrototypeDataView(fromNib: couponHeaderNib, updateMethod: { (header, coupon) -> Void in
            let width = UIApplication.sharedApplication().keyWindow!.bounds.size.width
            header.userLocation = self.userLocation
            header.loadImages = false
            header.preferredWidth = width
            header.coupon = coupon
        })
        
        collectionView.registerNib(couponHeaderNib, forSupplementaryViewOfKind: CHTCollectionElementKindSectionHeader, withReuseIdentifier: couponHeaderId)
        
        couponCollectionHandler = CouponCollectionHandler(collectionView: collectionView, loadCouponMethod: { (page, perPage, onComplete) -> Void in
            if let coupon = self.coupon {
                let pagination = PaginationInfo(page: page, perPage: perPage)
                self.offersService.findRelatedOffer(toOffer: coupon, pagination: pagination, completion: onComplete)
            }
            else {
                self.couponCollectionHandler?.clear()
            }
        })
        couponCollectionHandler!.onContextActionSelected = { action, coupon in
            switch action {
            case .Save: PersistenceService.sharedInstance.saveOfferId(coupon.id)
            case .Remove: PersistenceService.sharedInstance.removeOfferId(coupon.id)
            case .ShowMap: self.showMap(forOffer: coupon)
            case .Share: self.share(offer: coupon)
            }
        }
        
        couponCollectionHandler!.userLocation = userLocation
        couponCollectionHandler!.reloadAnimated = false
    }
    
    func refreshUI() {
        if let coupon = self.coupon {
            couponCollectionHandler?.layout.headerHeight = calculateHeaderHeight(forCoupon: coupon)
            collectionView?.reloadData()
            couponHeaderView?.coupon = coupon
        }
    }
    
    func reloadRelatedCoupons() {
        couponCollectionHandler?.reloadCoupons()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView?.contentOffset = CGPointZero
        couponCollectionHandler?.clear()
    }
    
    func calculateHeaderHeight(forCoupon coupon: Coupon) -> CGFloat {
        return prototypeHeaderView.getUpdatedSize(data: coupon).height
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if (kind == CHTCollectionElementKindSectionHeader) {
            couponHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: couponHeaderId, forIndexPath: indexPath) as! CouponDetailHeaderView
            couponHeaderView.userLocation = userLocation
            couponHeaderView.coupon = coupon
            couponHeaderView.delegate = self
            return couponHeaderView
        }
        return couponCollectionHandler!.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
    func collectionView (collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return couponCollectionHandler!.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return couponCollectionHandler!.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return couponCollectionHandler!.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        couponCollectionHandler?.collectionView(collectionView, willDisplayCell: cell, forItemAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath
        
        if let showDetailsDelegate = self.showDetailsDelegate {
            showDetailsDelegate(cell: self, coupons: couponCollectionHandler!.coupons, selectedIndex: selectedIndex?.row ?? 0)
        }
    }
    
    func showMap(forOffer offer: Coupon) {
        showMapDelegate?(cell: self, coupon: offer)
    }
    
    func showLink(forOffer offer: Coupon) {
        if let link = offer.link {
            // TODO: Ask for confirmation?
            UIApplication.sharedApplication().openURL(link)
        }
    }
    
    func share(offer offer: Coupon) {
        shareDelegate?(cell: self, coupon: offer)
    }
    
    func showDescription(forOffer offer: Coupon) {
        showDescriptionDelegate?(cell: self, coupon: offer)
    }
    
    func showCompanyView(forOffer offer: Coupon) {
        showCompanyDelegate?(cell: self, coupon: offer)
    }
    
    func showCodeView(forOffer offer: Coupon) {
        showRedemptionCodeDelegate?(cell: self, coupon: offer)
    }
    
    func getSelectedCell() -> CouponCollectionViewCell {
        return self.collectionView.scrollToAndGetCell(atIndexPath: selectedIndex) as! CouponCollectionViewCell
    }
    
    func headerViewDidSelectAction(action: HeaderViewAction, headerView: CouponDetailHeaderView) {
        switch action {
        case .ShowMap: showMap(forOffer: headerView.coupon)
        case .Share: share(offer: headerView.coupon)
        case .ShowDescription: showDescription(forOffer: headerView.coupon)
        case .ShowCompany: showCompanyView(forOffer: headerView.coupon)
        case .ShowLink: showLink(forOffer: headerView.coupon)
        case .ShowCode: showCodeView(forOffer: headerView.coupon)
        }
    }

}
