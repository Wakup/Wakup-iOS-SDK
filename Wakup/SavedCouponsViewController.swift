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
    var locationTimestamp: NSDate?
    var locationExpirationTime: NSTimeInterval = 5 * 60
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
                self.offersService.getOfferDetails(savedOfferIds, location: self.location!.coordinate, completion: onComplete)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        couponCollectionHandler?.refreshControl.endRefreshing() // iOS 9 UIRefreshControl issue
    }
    
    // MARK: Collection View methods
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        return couponCollectionHandler!.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        couponCollectionHandler?.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        selectedRow = indexPath.row
        performSegueWithIdentifier(showDetailsSegueId, sender: self)
    }
    
    // MARK: CLLocationManagerDelegate methods
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NSLog("AuthorizationStatusChanged: %d", status.rawValue)
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse where locationExpired: reload()
        default: break
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error obtaining location: %@", error.localizedDescription)
        couponCollectionHandler?.cancel()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        NSLog("Received location update %@", newLocation)
        self.location = newLocation
        self.locationTimestamp = NSDate()
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        reload()
    }
    
    
    // MARK: Transition methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == showDetailsSegueId) {
            let vc = segue.destinationViewController as! CouponDetailsViewController
            vc.userLocation = location
            vc.coupons = couponCollectionHandler!.coupons
            vc.selectedIndex = selectedRow
            vc.onSelectionChanged = { coupon, row in
                self.selectedRow = row
            }
        }
    }
    
    func zoomTransitionOriginView() -> UIView {
        let indexPath = NSIndexPath(forRow: selectedRow, inSection: 0)
        let cell = self.collectionView?.scrollToAndGetCell(atIndexPath: indexPath) as! CouponCollectionViewCell
        return cell.couponImageView
    }
    
    // MARK: DZNEmptyDataSetDelegate and DZNEmptyDataSetSource
    var lastRequestFailed: Bool { get { return couponCollectionHandler?.lastRequestFailed ?? false } }
    let emptyViewColor = UIColor(fromHexString: "#908E90")
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(18),
            NSForegroundColorAttributeName: emptyViewColor
        ]
        let title = lastRequestFailed ? "ConnectionErrorViewTitle".i18n() : "EmptyMyOffersTitle".i18n()
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        if lastRequestFailed {
            return CodeIcon(iconIdentifier: "cloud-alert").getImage(CGRectMake(0, 0, 150, 100))
        }
        else {
            return CodeIcon(iconIdentifier: "save").getImage(CGRectMake(0, 0, 90, 90))
        }
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: emptyViewColor
        ]
        let description = lastRequestFailed ? "ConnectionErrorViewMsg".i18n() : "EmptyMyOffersDescription".i18n()
        return NSAttributedString(string: description, attributes: attributes)
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return lastRequestFailed || !(couponCollectionHandler?.loading ?? false)
    }
    
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        if lastRequestFailed {
            reload()
        }
    }
    
    func offsetForEmptyDataSet(scrollView: UIScrollView!) -> CGPoint {
        // Minor tweak to center the view in the screen, not the Scroll view
        return CGPoint(x: 0, y: -scrollView.contentInset.top / 2)
    }
    
}