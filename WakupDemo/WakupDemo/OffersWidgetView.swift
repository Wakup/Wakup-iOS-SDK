//
//  OffersWidgetView.swift
//  WakupDemo
//
//  Created by Guillermo Gutiérrez Doral on 27/10/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit
import Wakup
import CoreLocation
import DZNEmptyDataSet

enum Status {
    case idle
    case loading
    case fetchingLocation
    case locationFailed(error: Error)
    case offersFailed(error: Error)
    case permissionDenied
    case awaitingPermission
}

@objc
open class OffersWidgetView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CLLocationManagerDelegate {
    
    @IBInspectable public var offerCellNib: String?
    @IBInspectable public var offerCellId = "cellId"
    
    @IBOutlet open var collectionView: UICollectionView!
    
    var onOfferSelected: ((Coupon) -> Void)?
    
    public var offers = [Coupon]()
    var location: CLLocation?
    
    var status: Status = .idle { didSet { self.collectionView?.reloadEmptyDataSet() } }
    
    private let locationManager = CLLocationManager()
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if let offerCellNib = offerCellNib {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: offerCellNib, bundle: bundle)
            collectionView.register(nib, forCellWithReuseIdentifier: offerCellId)
        }
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.reloadData()
    }
    
    func fetchOffers() {
        guard let location = location else { return }
        status = .loading
        offers = [Coupon]()
        collectionView.reloadData()
        OffersService.sharedInstance.findOffers(usingLocation: location.coordinate, sensor: true, pagination: PaginationInfo(perPage: 5)) { offers, error in
            self.status = .loading
            if let error = error {
                print("Error loading offers: ", error)
                self.status = .offersFailed(error: error)
            }
            else if let offers = offers {
                self.offers = offers
                self.collectionView.reloadData()
                self.status = .idle
            }
        }
    }
    
    func fetchLocation() {
        self.status = .fetchingLocation
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func fetchLocationIfAvailable() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            fetchLocation()
        case .notDetermined:
            status = .awaitingPermission
        case .denied, .restricted:
            status = .permissionDenied
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        // Adjust collection view margins and item size to new frame size
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let height = frame.height - layout.sectionInset.top - layout.sectionInset.bottom
        let width = frame.width - layout.minimumLineSpacing
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        UIApplication.shared.openURL(settingsUrl)
    }
    
    // MARK: UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offerCellId, for: indexPath)
        if let cell = cell as? CouponCollectionViewCell {
            cell.coupon = offers[indexPath.row]
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        onOfferSelected?(offer)
    }
    
    // MARK: CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        fetchOffers()
        manager.delegate = nil
        manager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error obtaining location: %@", error.localizedDescription)
        let locationDenied = CLLocationManager.authorizationStatus() == .denied
        status = locationDenied ? .permissionDenied : .locationFailed(error: error)
    }

    // MARK: DZNEmptyDataSetSource
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text: String?
        switch status {
        case .locationFailed:
            text = "LOCATION_ERROR_TITLE"
        case .permissionDenied:
            text = "LOCATION_PERMISSION_ERROR_TITLE"
        case .offersFailed:
            text = "OFFERS_SERVER_ERROR_TITLE"
        case .awaitingPermission:
            text = "AWAITING_PERMISSION_TITLE"
        case .idle:
            text = "NO_OFFERS_TITLE"
        default:
            break
        }
        return text.map { NSAttributedString(string: NSLocalizedString($0, comment: "")) }
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text: String?
        switch status {
        case .locationFailed:
            text = "LOCATION_ERROR_DESC"
        case .permissionDenied:
            text = "LOCATION_PERMISSION_ERROR_DESC"
        case .offersFailed:
            text = "OFFERS_SERVER_ERROR_DESC"
        case .awaitingPermission:
            text = "AWAITING_PERMISSION_DESC"
        case .idle:
            text = "NO_OFFERS_DESC"
        default:
            break
        }
        return text.map { NSAttributedString(string: NSLocalizedString($0, comment: "")) }
    }
    
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        var text: String?
        switch status {
        case .locationFailed:
            text = "LOCATION_ERROR_ACTION"
        case .permissionDenied:
            text = "LOCATION_PERMISSION_ERROR_ACTION"
        case .offersFailed:
            text = "OFFERS_SERVER_ERROR_ACTION"
        case .awaitingPermission:
            text = "AWAITING_PERMISSION_ACTION"
        case .idle:
            text = "NO_OFFERS_ACTION"
        default:
            break
        }
        let attrs = [NSForegroundColorAttributeName: UIColor.lightGray]
        return text.map { NSAttributedString(string: NSLocalizedString($0, comment: ""), attributes: attrs) }
    }
    
    
    public func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        switch status {
        case .loading, .fetchingLocation:
            let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            view.startAnimating()
            return view
        default:
            return nil
        }
    }
    
    // MARK: DZNEmptyDataSetDelegate
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        switch status {
        case .permissionDenied, .awaitingPermission, .locationFailed, .idle,
             .offersFailed where location == nil:
            fetchLocation()
        case .offersFailed:
            fetchOffers()
        default:
            break
        }
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        switch status {
        case .permissionDenied:
            openAppSettings()
        case .awaitingPermission, .locationFailed, .idle,
             .offersFailed where location == nil:
            fetchLocation()
        case .offersFailed:
            fetchOffers()
        default:
            break
        }
    }
}
