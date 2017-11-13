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
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "couponDescription") as? CouponDescriptionViewController else { return }
        
        vc.descriptionText = offer.description
        
        presenter.modalPresentationStyle = .currentContext;
        if #available(iOS 8.0, *) {
            vc.modalPresentationStyle = .overFullScreen
        }
        presenter.present(vc, animated: false, completion: nil)
    }
    
    func showCompanyView(forOffer offer: Coupon) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: CouponWaterfallViewController.storyboardId) as? CouponWaterfallViewController else { return }
            
        vc.forcedLocation = userLocation
        vc.filterTitle = offer.company.name
        vc.filterOptions = FilterOptions(searchTerm: nil, tags: nil, companyId: offer.company.id)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTagView(forTag tag: String) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: CouponWaterfallViewController.storyboardId) as? CouponWaterfallViewController else { return }
        
        vc.forcedLocation = userLocation
        vc.filterTitle = "#" + tag
        vc.filterOptions = FilterOptions(searchTerm: nil, tags: [tag], companyId: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showRedemptionCode(_ code: RedemptionCode, forOffer offer: Coupon) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "redemptionCode") as? RedemptionCodeViewController else { return }
        vc.offer = offer
        vc.redemptionCode = code
        
        let presenter = self.navigationController ?? self
        presenter.modalPresentationStyle = .currentContext;
        if #available(iOS 8.0, *) {
            vc.modalPresentationStyle = .overFullScreen
        }
        presenter.present(vc, animated: true, completion: nil)
    }
    
    @objc func dismissAction(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.layoutIfNeeded()
        
        for cell in collectionView?.visibleCells ?? [] {
            guard let cell = cell as? CouponDetailCollectionViewCell else { continue }
            cell.couponCollectionHandler?.refreshControl.endRefreshing()
        }
        
        if let navBarTintColor = navigationController?.navigationBar.tintColor {
            menuButton.iconColor = navBarTintColor
            menuButton.highlightedIconColor = navBarTintColor.colorWithAlpha(0.5)
        }
        
        if let navigationController = navigationController , navigationController.presentingViewController != nil && navigationController.viewControllers.first == self && navigationItem.leftBarButtonItem == nil {
            
            let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(CouponDetailsViewController.dismissAction(_:)))
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib(nibName: "CouponDetailCollectionViewCell", bundle: CurrentBundle.currentBundle()), forCellWithReuseIdentifier: couponCellId)
        view.backgroundColor = collectionView?.backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.scrollToIndexPathIfNotVisible(selectedIndexPath())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let segueIdentifier = segue.identifier, let offer = selectedCoupon else { return }
        
        switch segueIdentifier {
        case "reportError":
            let vc = segue.destination as! WebViewController
            vc.url = URL(string: OffersService.sharedInstance.reportErrorUrl(forOffer: offer))
        default:
            break
        }
    }
    
    // MARK: UICollectionView
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: couponCellId, for: indexPath) as! CouponDetailCollectionViewCell
        cell.userLocation = userLocation
        cell.coupon = coupons[(indexPath as NSIndexPath).row]
        cell.showDetailsDelegate = { cell, couponList, selectedIndex in
            let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: self.detailsStoryboardId) as! CouponDetailsViewController
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
                    if let code = offer.redemptionCode , code.limited && !code.alreadyAssigned {
                        let newCode = RedemptionCodeInfo(limited: code.limited, totalCodes: code.totalCodes, availableCodes: code.availableCodes.map{$0-1}, alreadyAssigned: true)
                        offer.redemptionCode = newCode
                        cell.refreshUI()
                    }
                }
                else {
                    let msg = (error as NSError?)?.localizedDescription ?? "ErrorGettingRedemptionCodeMsg".i18n()
                    let alert = UIAlertController(title: "ErrorGettingRedemptionCodeTitle".i18n(), message: msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "CloseDialogButton".i18n(), style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
                
            }
        }
        cell.showTagDelegate = { [unowned self] cell, tag in
            self.showTagView(forTag: tag)
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CouponDetailCollectionViewCell else { return }
        delay(0) {
            if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                cell.reloadRelatedCoupons()
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let visibleIndexPath = self.collectionView?.indexPathsForVisibleItems.first {
            let newSelectedItem = (visibleIndexPath as NSIndexPath).row
            if newSelectedItem != self.selectedIndex {
                self.selectedIndex = newSelectedItem
                if let listener = onSelectionChanged {
                    listener(selectedCoupon, newSelectedItem)
                }
            }
        }
    }
    
    // MARK: IBActions
    @IBAction func menuAction(_ sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "ReportErrorMessage".i18n(), preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "ReportErrorCancel".i18n(), style: .cancel) { (action) in })
        alertController.addAction(UIAlertAction(title: "ReportErrorButton".i18n(), style: .destructive) { (action) in
            self.performSegue(withIdentifier: "reportError", sender: self)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Transition methods
    func selectedIndexPath() -> IndexPath{
        return IndexPath(row: self.selectedIndex, section: 0)
    }
    
    func getSelectedCell() -> CouponDetailCollectionViewCell {
        return self.collectionView!.scrollToAndGetCell(atIndexPath: selectedIndexPath()) as! CouponDetailCollectionViewCell
    }
    
    func zoomTransitionDestinationView() -> UIView {
        let header = getSelectedCell().couponHeaderView
        if (!(header?.couponDetailImageView.isHidden)!) {
            return header!.couponDetailImageView
        }
        return header!.couponImageView
    }
    
    func zoomTransitionOriginView() -> UIView {
        return getSelectedCell().getSelectedCell().couponImageView
    }

}
