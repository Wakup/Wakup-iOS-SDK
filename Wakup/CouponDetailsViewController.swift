//
//  CouponDetailsViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 11/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import UIKit
import CoreLocation

class CouponDetailsViewController: LoadingPresenterViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, ZoomTransitionDestination, ZoomTransitionOrigin {

    @IBOutlet var collectionView: UICollectionView!
    
    var coupons: [Coupon]!
    var userLocation: CLLocation?
    
    var selectedIndex = 0
    var selectedCoupon: Coupon? { get { return coupons?[selectedIndex] } }
    
    
    let couponCellId = "CouponDetailCollectionViewCell"
    let detailsStoryboardId = "couponDetails"
    
    var onSelectionChanged: ((Coupon?, Int) -> Void)?
    
    func showDescription(forOffer offer: Coupon) {
        let presenter = self.navigationController ?? self
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("couponDescription") as? CouponDescriptionViewController {
        
            vc.descriptionText = offer.description
            
            presenter.modalPresentationStyle = .CurrentContext;
            if #available(iOS 8.0, *) {
                vc.modalPresentationStyle = .OverFullScreen
            }
            presenter.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func showCompanyView(forOffer offer: Coupon) {
        if let vc = storyboard?.instantiateViewControllerWithIdentifier(CouponWaterfallViewController.storyboardId) as? CouponWaterfallViewController {
            
            vc.filterTitle = offer.company.name
            vc.filterOptions = FilterOptions(searchTerm: nil, categories: nil, companyId: offer.company.id)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: View lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.layoutIfNeeded()
        if navigationController?.viewControllers.contains(self) ?? false {
            self.collectionView?.scrollToIndexPathIfNotVisible(selectedIndexPath())
        }
        
        for cell in collectionView?.visibleCells() ?? [] {
            guard let cell = cell as? CouponDetailCollectionViewCell else { continue }
            cell.couponCollectionHandler?.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerNib(UINib(nibName: "CouponDetailCollectionViewCell", bundle: CurrentBundle.currentBundle()), forCellWithReuseIdentifier: couponCellId)
        self.view.backgroundColor = collectionView?.backgroundColor
    }
    
    // MARK: UICollectionView
    func collectionView (collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(couponCellId, forIndexPath: indexPath) as! CouponDetailCollectionViewCell
        cell.userLocation = userLocation
        cell.coupon = coupons[indexPath.row]
        cell.showDetailsDelegate = { cell, couponList, selectedIndex in
            let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier(self.detailsStoryboardId) as! CouponDetailsViewController
            detailsVC.userLocation = self.userLocation
            detailsVC.coupons = couponList
            detailsVC.selectedIndex = selectedIndex
            detailsVC.onSelectionChanged = { coupon, index in
                self.getSelectedCell().selectionChanged(couponIndex: index)
            }
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        cell.showMapDelegate = { cell, coupon in
            self.showMap(forOffer: coupon)
        }
        cell.shareDelegate = { cell, coupon in
            self.shareCoupon(coupon)
        }
        cell.showDescriptionDelegate = { cell, coupon in
            self.showDescription(forOffer: coupon)
        }
        cell.showCompanyDelegate = { cell, coupon in
            self.showCompanyView(forOffer: coupon)
        }
        return cell;
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let visibleIndexPath = self.collectionView?.indexPathsForVisibleItems().first {
            let newSelectedItem = visibleIndexPath.row
            if newSelectedItem != self.selectedIndex {
                self.selectedIndex = newSelectedItem
                if let listener = onSelectionChanged {
                    listener(selectedCoupon, newSelectedItem)
                }
            }
        }
    }
    
    // MARK: Transition methods
    func selectedIndexPath() -> NSIndexPath{
        return NSIndexPath(forRow: self.selectedIndex, inSection: 0)
    }
    
    func getSelectedCell() -> CouponDetailCollectionViewCell {
        return self.collectionView!.scrollToAndGetCell(atIndexPath: selectedIndexPath()) as! CouponDetailCollectionViewCell
    }
    
    func zoomTransitionDestinationView() -> UIView {
        let header = getSelectedCell().couponHeaderView
        if (!header.couponDetailImageView.hidden) {
            return header.couponDetailImageView
        }
        return header.couponImageView
    }
    
    func zoomTransitionOriginView() -> UIView {
        return getSelectedCell().getSelectedCell().couponImageView
    }

}
