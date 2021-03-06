//
//  WakupManager.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 17/12/15.
//  Copyright © 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

@objc
open class WakupManager: NSObject {
    @objc public static let manager = WakupManager()
    @objc public static let appearance = WakupAppearance()
    
    internal var options = WakupOptions()
    
    @objc open func setup(_ apiKey: String, options: WakupOptions = WakupOptions()) {
        SearchService.sharedInstance.apiKey = apiKey
        OffersService.sharedInstance.apiKey = apiKey
        UserService.sharedInstance.apiKey = apiKey
        
        self.options = options
        CodeIconLibrary.instance = options.iconLibrary
    }
    
    @objc open lazy var storyboard: UIStoryboard! = UIStoryboard(name: "Wakup", bundle: Bundle(for: WakupManager.self))
    
    @objc open func rootNavigationController() -> UINavigationController! {
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    @objc open func rootController() -> UIViewController! {
        return storyboard.instantiateViewController(withIdentifier: "couponWaterfall")
    }
    
    @objc open func webViewController() -> WebViewController! {
        return storyboard.instantiateViewController(withIdentifier: "webViewController") as? WebViewController
    }
    
    open func offerDetailsController(forOffer offer: Coupon, userLocation: CLLocation?, offers: [Coupon]? = nil) -> UIViewController! {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "couponDetails") as? CouponDetailsViewController else { return nil }
        vc.userLocation = userLocation
        if let offers = offers, !offers.isEmpty {
            vc.coupons = offers
            vc.selectedIndex = offers.firstIndex(of: offer) ?? 0
        }
        else {
            vc.coupons = [offer]
            vc.selectedIndex = 0
        }
        
        return vc
    }
    
    @objc open func setAlias(alias: String, _ completion: ((Error?) -> Void)? = nil) {
        UserService.sharedInstance.setAlias(alias: alias, completion ?? { _ in })
    }
    
    open func mapController(for offer: Coupon) -> CouponMapViewController {
        let mapVC = storyboard.instantiateViewController(withIdentifier: "couponMap") as! CouponMapViewController
        mapVC.coupons = [offer]
        mapVC.selectedCoupon = offer
        return mapVC
    }
}

import CoreLocation
@objc
open class WakupOptions: NSObject {
    open var iconLibrary: IconLibrary = DefaultIconLibrary()
    
    /// Default user location, used when there's no user location available
    @objc open var defaultLocation = CLLocation(latitude: 40.416944, longitude: -3.703611) // Puerta del Sol, Madrid
    
    /// Search country, will be appended to geolocation searches to narrow results
    @objc open var searchCountryCode: String? = "es" // NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String
    
    /// Category definition. Used for search controller shortcuts. Set to nil to disable category search.
    open var searchCategories: [OfferCategory]? = [
        OfferCategory(title: "Comida", icon: "restaurant", associatedTags: ["restaurants"]),
        OfferCategory(title: "Tiendas", icon: "shopping", associatedTags: ["shopping"]),
        OfferCategory(title: "Ocio", icon: "leisure", associatedTags: ["leisure"]),
        OfferCategory(title: "Servicios", icon: "services", associatedTags: ["services"])
    ]
    
    /// Custom Function for sharing an Offer. Use it to completely take control over the offer sharing mechanism.
    /// The block takes three parameters:
    /// - offer: Coupon: The offer that is being shared. All offer information can be accessed
    /// - presenter: UIViewController: the view controller that triggers the share action. Use it to present modal controllers if needed.
    /// - loadingProtocol: LoadingViewProtocol: provides convenience methods to show and hiding a modal dialog.
    open var customShareFunction: ((Coupon, UIViewController, LoadingViewProtocol) -> Void)? = nil
    
    public override init() {}
}
