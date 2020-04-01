//
//  CouponMapViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 08/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable
open class CouponMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicatorView: ScissorsLoadingView!
    
    let numberOfCouponsToCenter = 5
    
    open var coupons: [Coupon] = [Coupon]()
    open var selectedCoupon: Coupon?
    open var userLocation: CLLocation?
    open var allowDetailsNavigation = false
    var selectedAnnotation: CouponAnnotation? { get { return selectedCoupon.map{ self.annotations[$0.id] } ?? .none } }
    
    // Used to customize and filter the offer query
    open var filterOptions: FilterOptions?
    
    open var loadCouponsOnRegionChange = false
    fileprivate var shouldLoad = false
    fileprivate var lastRequestCenter: CLLocationCoordinate2D?
    
    fileprivate var annotations = [Int: CouponAnnotation]()
    
    fileprivate var loading: Bool = false {
        didSet {
            self.loadingIndicatorView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.loadingIndicatorView?.alpha = self.loading ? 1 : 0
                return
            })
        }
    }
    
    let selectionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    let offersService = OffersService.sharedInstance
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView?.showsUserLocation = true
        loadingIndicatorView.isHidden = true
        loadingIndicatorView?.alpha = 0
        
        if let navigationController = navigationController {
            loadingIndicatorView.fillColor = navigationController.navigationBar.tintColor
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !shouldLoad {
            if let coupon = selectedCoupon {
                selectCoupon(coupon, animated: true)
            }
            else {
                centerInSelection(animated)
            }
        }
        
        // Ignore first animations
        delay(2) {
            self.shouldLoad = true
            return
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.showsUserLocation = false
    }
    
    // MARK: Private Methods
    func refreshUI() {
        mapView?.removeAnnotations(mapView.annotations)
        annotations.removeAll(keepingCapacity: false)
        
        for coupon in coupons {
            guard coupon.store?.location() != nil else { continue }
            let annotation = CouponAnnotation(coupon: coupon)
            
            mapView?.addAnnotation(annotation)
            annotations[coupon.id] = annotation
        }
    }
    
    func reloadCoupons() {
        guard let mapView = mapView else { return }
        let center = mapView.region.center
        let span = mapView.region.span
        
        let corner = CLLocation(latitude: center.latitude + span.latitudeDelta / 2, longitude: center.longitude + span.longitudeDelta / 2)
        let radius = corner.distance(from: center.toLocation())
        
        self.lastRequestCenter = center
        self.loading = true
        NSLog("Requesting coupons for center %f, %f with radius %f meters", center.latitude, center.longitude, radius)
        offersService.findStoreOffers(nearLocation: center, radius: radius, sensor: false, filterOptions: filterOptions, completion: { (coupons, error) -> Void in
            self.loading = false
            if let error = error {
                NSLog("Error loading coupons: \(error)")
            }
            else {
                // Add only offers from new stores
                let storeIds = self.coupons.map{ $0.store?.id ?? -1 }
                let newCoupons = (coupons ?? [Coupon]()).filter{ !storeIds.contains($0.store?.id ?? 0) }
                let annotations = newCoupons.map{ CouponAnnotation(coupon: $0) }
                
                self.coupons += newCoupons
                mapView.addAnnotations(annotations)
            }
        })
    }
    
    func selectCoupon(_ coupon: Coupon, animated: Bool = false) {
        selectedCoupon = coupon
        guard let annotation = self.annotations[coupon.id] else { return }
        self.centerInAnnotations([annotation], animated: animated)
        delay(1) {
            self.mapView?.selectAnnotation(annotation, animated: animated)
            return
        }
    }
    
    func centerInSelection(_ animated: Bool) {
        var annotations = [CouponAnnotation]()
        if let selectedAnnotation = self.selectedAnnotation {
            annotations = [selectedAnnotation]
        }
        else if (self.annotations.count > 0) {
            let limit = min(self.annotations.count, numberOfCouponsToCenter)
            annotations = Array(self.annotations.values.prefix(limit))
        }
        centerInAnnotations(annotations, animated: animated)
    }
    
    func centerInCoordinate(_ coordinate: CLLocationCoordinate2D, animated: Bool) {
        let region = MKCoordinateRegion(center: coordinate, span: selectionSpan)
        self.mapView?.setRegion(region, animated: animated)
    }
    
    func centerInAnnotations(_ annotations: [CouponAnnotation], animated: Bool) {
        if annotations.count > 0 {
            mapView?.showAnnotations(annotations, animated: animated)
        }
    }
    
    // MARK: Actions
    func showDetails(forOffer offer: Coupon) {
        let detailsStoryboardId = "couponDetails"
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: detailsStoryboardId) as! CouponDetailsViewController
        detailsVC.userLocation = self.userLocation
        detailsVC.coupons = coupons
        detailsVC.selectedIndex = coupons.firstIndex(of: offer) ?? 0
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // MARK: MKMapViewDelegate methods
    open func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return (annotation as? CouponAnnotation).map { couponAnnotation in
            let identifier = "couponAnnotation"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? CouponAnnotationView(annotation: couponAnnotation, reuseIdentifier: identifier)
            annotationView.layoutSubviews()
            annotationView.annotation = couponAnnotation
            annotationView.canShowCallout = true
            
            if couponAnnotation.coupon.company.logo?.sourceUrl != nil {
                if !(annotationView.leftCalloutAccessoryView is UIImageView) {
                    let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 52, height: 52)))
                    imageView.contentMode = .scaleAspectFit
                    annotationView.leftCalloutAccessoryView = imageView
                }
            }
            else {
                annotationView.leftCalloutAccessoryView = nil
            }
            
            if allowDetailsNavigation {
                let button = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = button
            }
            annotationView.setNeedsLayout()
            return annotationView
        }
    }
    
    open func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? CouponAnnotation {
            showDetails(forOffer: annotation.coupon)
        }
    }
    
    open func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CouponAnnotation,
            let imageView = view.leftCalloutAccessoryView as? UIImageView,
            let logoUrl = annotation.coupon.company.logo?.sourceUrl else { return }
        
        imageView.sd_setImage(with: logoUrl)
    }
    
    open func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        NSLog("Region changed with new center: %f, %f", mapView.region.center.latitude, mapView.region.center.longitude)
        if loadCouponsOnRegionChange && shouldLoad {
            let center = mapView.region.center
            delay(0.5) {
                // If center hasn't changed in X seconds, reload results
                if center.isEqualTo(mapView.region.center) {
                    self.reloadCoupons()
                }
            }
        }
    }
    
}
