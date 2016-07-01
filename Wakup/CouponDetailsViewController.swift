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
    @IBOutlet weak var menuButton: CodeIconButton!
    
    var coupons: [Coupon]!
    var userLocation: CLLocation?
    
    var selectedIndex = 0
    var selectedCoupon: Coupon? { get { return coupons?[selectedIndex] } }
    
    
    let couponCellId = "CouponDetailCollectionViewCell"
    let detailsStoryboardId = "couponDetails"
    
    var onSelectionChanged: ((Coupon?, Int) -> Void)?
    
    func showDescription(forOffer offer: Coupon) {
        let presenter = self.navigationController ?? self
        
        guard let vc = storyboard?.instantiateViewControllerWithIdentifier("couponDescription") as? CouponDescriptionViewController else { return }
        
        vc.descriptionText = offer.description
        
        presenter.modalPresentationStyle = .CurrentContext;
        if #available(iOS 8.0, *) {
            vc.modalPresentationStyle = .OverFullScreen
        }
        presenter.presentViewController(vc, animated: true, completion: nil)
    }
    
    func showCompanyView(forOffer offer: Coupon) {
        guard let vc = storyboard?.instantiateViewControllerWithIdentifier(CouponWaterfallViewController.storyboardId) as? CouponWaterfallViewController else { return }
            
        vc.forcedLocation = userLocation
        vc.filterTitle = offer.company.name
        vc.filterOptions = FilterOptions(searchTerm: nil, categories: nil, companyId: offer.company.id)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showRedemptionCode(code: RedemptionCode, forOffer offer: Coupon) {
        guard let vc = storyboard?.instantiateViewControllerWithIdentifier("redemptionCode") as? RedemptionCodeViewController else { return }
        vc.offer = offer
        vc.redemptionCode = code
        
        let presenter = self.navigationController ?? self
        presenter.modalPresentationStyle = .CurrentContext;
        if #available(iOS 8.0, *) {
            vc.modalPresentationStyle = .OverFullScreen
        }
        presenter.presentViewController(vc, animated: true, completion: nil)
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
        
        if let navBarTintColor = navigationController?.navigationBar.tintColor {
            menuButton.iconColor = navBarTintColor
            menuButton.highlightedIconColor = navBarTintColor.colorWithAlpha(0.5)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerNib(UINib(nibName: "CouponDetailCollectionViewCell", bundle: CurrentBundle.currentBundle()), forCellWithReuseIdentifier: couponCellId)
        self.view.backgroundColor = collectionView?.backgroundColor
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        guard let segueIdentifier = segue.identifier, offer = selectedCoupon else { return }
        
        switch segueIdentifier {
        case "reportError":
            let vc = segue.destinationViewController as! WebViewController
            vc.url = NSURL(string: OffersService.sharedInstance.reportErrorUrl(forOffer: offer))
        default:
            break
        }
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
        cell.showMapDelegate = { cell, offer in
            self.showMap(forOffer: offer)
        }
        cell.shareDelegate = { cell, offer in
            self.shareCoupon(offer)
        }
        cell.showDescriptionDelegate = { cell, offer in
            self.showDescription(forOffer: offer)
        }
        cell.showCompanyDelegate = { cell, offer in
            self.showCompanyView(forOffer: offer)
        }
        cell.showRedemptionCodeDelegate = { [unowned self] cell, offer in
            self.showLoadingView(animated: true)
            OffersService.sharedInstance.getRedemptionCode(forOffer: offer) { (code, error) in
                self.dismissLoadingView(animated: false)
                if let code = code {
                    self.showRedemptionCode(code, forOffer: offer)
                    // If limited offer, update UI with new values
                    if let code = offer.redemptionCode where code.limited && !code.alreadyAssigned {
                        let newCode = RedemptionCodeInfo(limited: code.limited, totalCodes: code.totalCodes, availableCodes: code.availableCodes.map{$0-1}, alreadyAssigned: true)
                        offer.redemptionCode = newCode
                        cell.refreshUI()
                    }
                }
                else {
                    let msg = (error as? NSError)?.localizedDescription ?? "ErrorGettingRedemptionCodeMsg".i18n()
                    UIAlertView(title: "ErrorGettingRedemptionCodeTitle".i18n(), message: msg, delegate: nil, cancelButtonTitle: "CloseDialogButton".i18n()).show()
                }
                
            }
        }
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? CouponDetailCollectionViewCell else { return }
        delay(0) {
            if collectionView.indexPathsForVisibleItems().contains(indexPath) {
                cell.reloadRelatedCoupons()
            }
        }
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
    
    // MARK: IBActions
    @IBAction func menuAction(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "ReportErrorMessage".i18n(), preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "ReportErrorCancel".i18n(), style: .Cancel) { (action) in })
        alertController.addAction(UIAlertAction(title: "ReportErrorButton".i18n(), style: .Destructive) { (action) in
            self.performSegueWithIdentifier("reportError", sender: self)
        })
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
