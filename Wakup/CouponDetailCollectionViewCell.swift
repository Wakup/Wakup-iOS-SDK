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
    
    var showDetailsDelegate: ((_ cell: CouponDetailCollectionViewCell, _ coupons: [Coupon], _ selectedIndex: Int) -> Void)?
    var showMapDelegate: ((_ cell: CouponDetailCollectionViewCell, _ coupon: Coupon) -> Void)?
    var shareDelegate: ((_ cell: CouponDetailCollectionViewCell, _ coupon: Coupon) -> Void)?
    var showDescriptionDelegate: ((_ cell: CouponDetailCollectionViewCell, _ coupon: Coupon) -> Void)?
    var showCompanyDelegate: ((_ cell: CouponDetailCollectionViewCell, _ coupon: Coupon) -> Void)?
    var showLinkDelegate: ((_ cell: CouponDetailCollectionViewCell, _ coupon: Coupon) -> Void)?
    var showRedemptionCodeDelegate: ((_ cell: CouponDetailCollectionViewCell, _ coupon: Coupon) -> Void)?
    var showTagDelegate: ((_ cell: CouponDetailCollectionViewCell, _ tag: String) -> Void)?
    
    var selectedIndex: IndexPath!
    
    let offersService = OffersService.sharedInstance
    
    func selectionChanged(couponIndex: Int) {
        selectedIndex = IndexPath(row: couponIndex, section: (selectedIndex as NSIndexPath?)?.section ?? 0)
    }
    
    override func awakeFromNib() {
        prototypeHeaderView = PrototypeDataView(fromNib: couponHeaderNib, updateMethod: { (header, coupon) -> Void in
            let width = UIApplication.shared.keyWindow!.bounds.size.width
            header.userLocation = self.userLocation
            header.loadImages = false
            header.preferredWidth = width
            header.coupon = coupon
        })
        
        collectionView.register(couponHeaderNib, forSupplementaryViewOfKind: CHTCollectionElementKindSectionHeader, withReuseIdentifier: couponHeaderId)
        
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
        collectionView?.contentOffset = CGPoint.zero
        couponCollectionHandler?.clear()
    }
    
    func calculateHeaderHeight(forCoupon coupon: Coupon) -> CGFloat {
        return prototypeHeaderView.getUpdatedSize(data: coupon).height
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == CHTCollectionElementKindSectionHeader) {
            couponHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: couponHeaderId, for: indexPath) as! CouponDetailHeaderView
            couponHeaderView.userLocation = userLocation
            couponHeaderView.coupon = coupon
            couponHeaderView.delegate = self
            return couponHeaderView
        }
        return couponCollectionHandler!.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return couponCollectionHandler!.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return couponCollectionHandler!.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return couponCollectionHandler!.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        couponCollectionHandler?.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        if let showDetailsDelegate = self.showDetailsDelegate {
            showDetailsDelegate(self, couponCollectionHandler!.coupons, (selectedIndex as NSIndexPath?)?.row ?? 0)
        }
    }
    
    func showMap(forOffer offer: Coupon) {
        showMapDelegate?(self, offer)
    }
    
    func showLink(forOffer offer: Coupon) {
        if let link = offer.link {
            // TODO: Ask for confirmation?
            UIApplication.shared.openURL(link as URL)
        }
    }
    
    func share(offer: Coupon) {
        shareDelegate?(self, offer)
    }
    
    func showDescription(forOffer offer: Coupon) {
        showDescriptionDelegate?(self, offer)
    }
    
    func showCompanyView(forOffer offer: Coupon) {
        showCompanyDelegate?(self, offer)
    }
    
    func showCodeView(forOffer offer: Coupon) {
        showRedemptionCodeDelegate?(self, offer)
    }
    
    func showTagResults(_ tag: String) {
        showTagDelegate?(self, tag)
    }
    
    func getSelectedCell() -> CouponCollectionViewCell {
        return self.collectionView.scrollToAndGetCell(atIndexPath: selectedIndex) as! CouponCollectionViewCell
    }
    
    func headerViewDidSelectAction(_ action: HeaderViewAction, headerView: CouponDetailHeaderView) {
        switch action {
        case .showMap: showMap(forOffer: headerView.coupon)
        case .share: share(offer: headerView.coupon)
        case .showDescription: showDescription(forOffer: headerView.coupon)
        case .showCompany: showCompanyView(forOffer: headerView.coupon)
        case .showLink: showLink(forOffer: headerView.coupon)
        case .showCode: showCodeView(forOffer: headerView.coupon)
        case .showTag(let tag): showTagResults(tag)
        }
    }

}
