//
//  CouponWaterfallViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit
import CHTCollectionViewWaterfallLayout
import CoreLocation
import DZNEmptyDataSet

@IBDesignable class CouponWaterfallViewController: LoadingPresenterViewController, UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, ZoomTransitionOrigin, CLLocationManagerDelegate, TopMenuViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var topMenuView: TopMenuView?
    @IBOutlet weak var searchButton: CodeIconButton!
    
    static let storyboardId = "couponWaterfall"
    
    let showDetailsSegueId = "showDetails"
    let highlightedOfferSegueId = "highlightedOffer"
    let mapStoryboardId = "couponMap"
    let savedOffersSegueId = "savedOffers"
    var selectedRow: Int = 0
    
    let layout = CHTCollectionViewWaterfallLayout()
    var couponCollectionHandler: CouponCollectionHandler?
    
    let locationManager = CLLocationManager()
    var location: CLLocation? { didSet { couponCollectionHandler?.userLocation = location } }
    var coordinate: CLLocationCoordinate2D { get { return (forcedLocation ?? location ?? defaultLocation).coordinate } }
    var locationTimestamp: Date?
    var locationExpirationTime: TimeInterval = 5 * 60
    var defaultLocationExpirationTime: TimeInterval = 10
    var locationExpired: Bool {
        get {
            if let timestamp = locationTimestamp {
                let elapsedTime = -timestamp.timeIntervalSinceNow
                var expiration = locationExpirationTime
                if isDefaultLocation {
                    expiration = defaultLocationExpirationTime
                }
                return elapsedTime > expiration
            }
            return true
        }
    }
    
    var defaultLocation = WakupManager.manager.options.defaultLocation
    var isDefaultLocation: Bool { get { return defaultLocation == location } }
    var nonDefaultLocation: Bool { get { return !isDefaultLocation } }
    
    let offersService = OffersService.sharedInstance
    
    // MARK: Search customization
    
    // Used to search offer around this location
    var forcedLocation: CLLocation? { didSet { couponCollectionHandler?.userLocation = forcedLocation } }

    // Used to customize and filter the offer query
    var filterOptions: FilterOptions?
    var filterTitle: String?
    
    
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
        
        topMenuView?.delegate = self
        collectionView?.collectionViewLayout = layout
        
        // Initialize CouponCollectionHandler with the load coupon method
        couponCollectionHandler = CouponCollectionHandler(collectionView: collectionView, loadCouponMethod: { (page, perPage, onComplete) -> Void in
            let pagination = PaginationInfo(page: page, perPage: perPage)
            let sensor = self.location.map { l in l.horizontalAccuracy > 0 } ?? false
            self.offersService.findOffers(usingLocation: self.coordinate, sensor: sensor, filterOptions: self.filterOptions, pagination: pagination, completion: onComplete)
        })
        
        couponCollectionHandler!.showFooterWhenReloading = false
        couponCollectionHandler!.onLoadingChanged = { loading in
            if loading {
                self.showLoadingView()
            } else {
                self.dismissLoadingView()
            }
        }

        couponCollectionHandler!.shouldLoadCoupons = { page in
            if (page == 0 && self.forcedLocation == nil && self.locationExpired) {
                self.fetchLocation()
                return false
            }
            return true
        }
        couponCollectionHandler!.onContextActionSelected = { action, coupon in
            switch action {
            case .Save: PersistenceService.sharedInstance.saveOfferId(coupon.id)
            case .Remove: PersistenceService.sharedInstance.removeOfferId(coupon.id)
            case .ShowMap: self.showMap(forOffer: coupon)
            case .Share: self.shareCoupon(coupon)
            }
        }
        couponCollectionHandler!.onErrorReceived = { error in
            // Reload empty data set to show error view
            self.collectionView?.reloadEmptyDataSet()
        }
        
        couponCollectionHandler!.userLocation = forcedLocation ?? location
        
        // Setup DZNEmptyDataSet
        collectionView?.emptyDataSetDelegate = self
        collectionView?.emptyDataSetSource = self
        
        self.view.backgroundColor = collectionView?.backgroundColor
        
        reload()
        
        if let title = filterTitle {
            navigationItem.titleView = nil
            navigationItem.title = title
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        couponCollectionHandler?.refreshControl.endRefreshing() // iOS 9 UIRefreshControl issue
        
        if let navBarTintColor = navigationController?.navigationBar.tintColor {
            searchButton.iconColor = navBarTintColor
            searchButton.highlightedIconColor = navBarTintColor.colorWithAlpha(0.5)
        }
        
        if let navigationController = navigationController , navigationController.presentingViewController != nil && navigationController.viewControllers.first == self && navigationItem.leftBarButtonItem == nil {
            
            let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(CouponWaterfallViewController.dismissAction(_:)))
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    // MARK: IBActions
    @IBAction func searchButtonTapped(_ sender: AnyObject) {
        let viewControllers = navigationController?.viewControllers ?? [UIViewController]()
        
        if let vc = viewControllers.filter({ $0 is SearchViewController }).first {
            _ = navigationController?.popToViewController(vc, animated: true)
        }
        else {
            performSegue(withIdentifier: "search", sender: self)
        }
    }
    
    func dismissAction(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
        case .authorizedAlways where locationExpired || isDefaultLocation,
             .authorizedWhenInUse where locationExpired || isDefaultLocation:
            reload()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error obtaining location: %@", error.localizedDescription)
        
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "GeolocationDeniedTitle".i18n(), message: "GeolocationDeniedMsg".i18n(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ApplicationSettings".i18n(), style: .default) { _ in
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "CloseDialogButton".i18n(), style: .default) { _ in })
                present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "GeolocationDeniedTitle".i18n(), message: "GeolocationDeniedMsg".i18n(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "CloseDialogButton".i18n(), style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        default:
            let alert = UIAlertController(title: "GeolocationErrorTitle".i18n(), message: "GeolocationErrorMsg".i18n(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CloseDialogButton".i18n(), style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        self.location = defaultLocation
        self.locationTimestamp = Date()
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        reload()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
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
            vc.userLocation = couponCollectionHandler?.userLocation
            vc.coupons = couponCollectionHandler!.coupons
            vc.selectedIndex = selectedRow
            vc.onSelectionChanged = { coupon, row in
                self.selectedRow = row
            }
        }
        else if (segue.identifier == highlightedOfferSegueId) {
            let vc = segue.destination as! WebViewController
            vc.url = URL(string: offersService.highlightedOfferUrl)
        }
        else if (segue.identifier == savedOffersSegueId) {
            let vc = segue.destination as! SavedCouponsViewController
            vc.location = location
            vc.locationTimestamp = locationTimestamp
        }
    }
    
    func zoomTransitionOriginView() -> UIView {
        let indexPath = IndexPath(row: selectedRow, section: 0)
        let cell = self.collectionView?.scrollToAndGetCell(atIndexPath: indexPath) as! CouponCollectionViewCell
        return cell.couponImageView
    }
    
    // MARK: TopMenuViewDelegate
    func topMenuViewDidSelectOfferButton(_ view: TopMenuView) {
        self.performSegue(withIdentifier: highlightedOfferSegueId, sender: self)
    }
    
    func topMenuViewDidSelectMapButton(_ view: TopMenuView) {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: self.mapStoryboardId) as! CouponMapViewController
        mapVC.coupons = couponCollectionHandler?.coupons.filter{ $0.store?.location() != nil } ?? [Coupon]()
        mapVC.filterOptions = filterOptions
        mapVC.loadCouponsOnRegionChange = true
        mapVC.userLocation = couponCollectionHandler?.userLocation
        mapVC.allowDetailsNavigation = true
        
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func topMenuViewDidSelectMyOffersButton(_ view: TopMenuView) {
        self.performSegue(withIdentifier: savedOffersSegueId, sender: self)
    }
    
    // MARK: DZNEmptyDataSetDelegate and DZNEmptyDataSetSource
    var lastRequestFailed: Bool { get { return couponCollectionHandler?.lastRequestFailed ?? false } }
    let emptyViewColor = UIColor(fromHexString: "#908E90")
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName: emptyViewColor
        ]
        let title = lastRequestFailed ? "ConnectionErrorViewTitle".i18n() : "EmptyOfferSearchTitle".i18n()
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if lastRequestFailed {
            return CodeIcon(iconIdentifier: "cloud-alert").getImage(CGRect(x: 0, y: 0, width: 150, height: 100))
        }
        else {
            return CodeIcon(iconIdentifier: "alert").getImage(CGRect(x: 0, y: 0, width: 90, height: 90))
        }
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: emptyViewColor
        ]
        let description = lastRequestFailed ? "ConnectionErrorViewMsg".i18n() : "EmptyOfferSearchDescription".i18n()
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
        if #available(iOS 8.0, *) {
            // This tweak is somehow required when mixing ShyBar and DZNEmptyDataSet
            return CGPoint(x: scrollView.frame.width / 2, y: scrollView.frame.height / 4)
        }
        else {
            // Minor tweak to center the view in the screen, not the Scroll view
            return CGPoint(x: 0, y: -scrollView.contentInset.top / 2)
        }
    }
    
}
