//
//  SavedCouponsViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 17/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import CoreLocation
import DZNEmptyDataSet
import CHTCollectionViewWaterfallLayout

class SavedCouponsViewController: LoadingPresenterViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate, ZoomTransitionOrigin, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    var couponCollectionHandler: CouponCollectionHandler?
    let layout = CHTCollectionViewWaterfallLayout()
    
    let showDetailsSegueId = "showDetails"
    var selectedRow: Int = 0
    
    let offersService = OffersService.sharedInstance
    let locationManager = CLLocationManager()
    var location: CLLocation? { didSet { couponCollectionHandler?.userLocation = location } }
    var coordinate: CLLocationCoordinate2D? { get { return location?.coordinate } }
    var locationTimestamp: Date?
    var locationExpirationTime: TimeInterval = 5 * 60
    var locationExpired: Bool {
        get {
            if let timestamp = locationTimestamp {
                let elapsedTime = -timestamp.timeIntervalSinceNow
                return elapsedTime > locationExpirationTime
            }
            return true
        }
    }
    
    let persistenceService = PersistenceService.sharedInstance
    
    @IBOutlet var collectionView: UICollectionView?
    
    func reload() {
        couponCollectionHandler?.reloadCoupons()
    }
    
    func fetchLocation() {
        locationManager.delegate = self
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    deinit {
        collectionView?.emptyDataSetDelegate = nil
        collectionView?.emptyDataSetSource = nil
    }
    
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.collectionViewLayout = layout
        
        // Initialize CouponCollectionHandler with the load coupon method
        couponCollectionHandler = CouponCollectionHandler(collectionView: collectionView, loadCouponMethod: { (page, perPage, onComplete) -> Void in
            let savedOfferIds = self.persistenceService.getSavedOfferIds(true)
            if savedOfferIds.count > 0 {
                guard let location = self.location else { return }
                self.offersService.getOfferDetails(savedOfferIds, location: location.coordinate, sensor: location.horizontalAccuracy > 0, completion: onComplete)
            }
            else {
                self.couponCollectionHandler?.cancel()
                Async.main {
                    // Reload in the next main thread cycle to allow the view hierarchy to compose
                    self.collectionView?.reloadEmptyDataSet()
                }
            }
        })
        
        couponCollectionHandler!.showFooterWhenReloading = false
        couponCollectionHandler!.enablePagination = false
        couponCollectionHandler!.onLoadingChanged = { loading in
            if loading {
                self.showLoadingView()
            } else {
                self.dismissLoadingView()
            }
        }
        couponCollectionHandler!.shouldLoadCoupons = { page in
            if (page == 0 && self.locationExpired) {
                self.fetchLocation()
                return false
            }
            return true
        }
        couponCollectionHandler!.onContextActionSelected = { action, coupon in
            switch action {
            case .Save: NSLog("WARNING: This shouldn't happen: 'Save' action in a saved offer")
            case .Remove:
                self.persistenceService.removeOfferId(coupon.id)
                self.couponCollectionHandler?.removeCoupon(coupon, animated: true)
            case .ShowMap: self.showMap(forOffer: coupon)
            case .Share: self.shareCoupon(coupon)
            }
        }
        couponCollectionHandler!.onErrorReceived = { error in
            // Reload empty data set to show error view
            self.collectionView?.reloadEmptyDataSet()
        }
        couponCollectionHandler!.userLocation = location
        
        self.view.backgroundColor = collectionView?.backgroundColor
        
        // Setup DZNEmptyDataSet
        collectionView?.emptyDataSetDelegate = self
        collectionView?.emptyDataSetSource = self
        
        reload()
        
//        // Setup Shy NavBar
//        shyNavBarManager.scrollView = self.collectionView
//        shyNavBarManager.expansionResistance = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        couponCollectionHandler?.refreshControl.endRefreshing() // iOS 9 UIRefreshControl issue
    }
    
    // MARK: Collection View methods
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return couponCollectionHandler!.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        couponCollectionHandler?.collectionView(collectionView, didSelectItemAt: indexPath)
        selectedRow = (indexPath as NSIndexPath).row
        performSegue(withIdentifier: showDetailsSegueId, sender: self)
    }
    
    // MARK: CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NSLog("AuthorizationStatusChanged: %d", status.rawValue)
        switch status {
        case .authorizedAlways where locationExpired,
             .authorizedWhenInUse where locationExpired:
            reload()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error obtaining location: %@", error.localizedDescription)
        couponCollectionHandler?.cancel()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        NSLog("Received location update %@", newLocation)
        self.location = newLocation
        self.locationTimestamp = Date()
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        reload()
    }
    
    
    // MARK: Transition methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == showDetailsSegueId) {
            let vc = segue.destination as! CouponDetailsViewController
            vc.userLocation = location
            vc.coupons = couponCollectionHandler!.coupons
            vc.selectedIndex = selectedRow
            vc.onSelectionChanged = { coupon, row in
                self.selectedRow = row
            }
        }
    }
    
    func zoomTransitionOriginView() -> UIView {
        let indexPath = IndexPath(row: selectedRow, section: 0)
        let cell = self.collectionView?.scrollToAndGetCell(atIndexPath: indexPath) as! CouponCollectionViewCell
        return cell.couponImageView
    }
    
    // MARK: DZNEmptyDataSetDelegate and DZNEmptyDataSetSource
    var lastRequestFailed: Bool { get { return couponCollectionHandler?.lastRequestFailed ?? false } }
    let emptyViewColor = UIColor(fromHexString: "#908E90")
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: emptyViewColor
        ]
        let title = lastRequestFailed ? "ConnectionErrorViewTitle".i18n() : "EmptyMyOffersTitle".i18n()
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if lastRequestFailed {
            return CodeIcon(iconIdentifier: "cloud-alert").getImage(CGRect(x: 0, y: 0, width: 150, height: 100))
        }
        else {
            return CodeIcon(iconIdentifier: "save").getImage(CGRect(x: 0, y: 0, width: 90, height: 90))
        }
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: emptyViewColor
        ]
        let description = lastRequestFailed ? "ConnectionErrorViewMsg".i18n() : "EmptyMyOffersDescription".i18n()
        return NSAttributedString(string: description, attributes: attributes)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return lastRequestFailed || !(couponCollectionHandler?.loading ?? false)
    }
    
    func emptyDataSetDidTap(_ scrollView: UIScrollView!) {
        if lastRequestFailed {
            reload()
        }
    }
    
    func offset(forEmptyDataSet scrollView: UIScrollView!) -> CGPoint {
        // Minor tweak to center the view in the screen, not the Scroll view
        return CGPoint(x: 0, y: -scrollView.contentInset.top / 2)
    }
    
}
