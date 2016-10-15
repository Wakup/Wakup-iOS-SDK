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
    open static let manager = WakupManager()
    
    internal var options = WakupOptions()
    
    open func setup(_ apiKey: String, options: WakupOptions = WakupOptions()) {
        SearchService.sharedInstance.apiKey = apiKey
        OffersService.sharedInstance.apiKey = apiKey
        UserService.sharedInstance.apiKey = apiKey
        
        self.options = options
        CodeIconLibrary.instance = options.iconLibrary
    }
    
    open lazy var storyboard: UIStoryboard! = UIStoryboard(name: "Wakup", bundle: Bundle(for: WakupManager.self))
    
    open func rootNavigationController() -> UINavigationController! {
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    open func rootController() -> UIViewController! {
        return storyboard.instantiateViewController(withIdentifier: "couponWaterfall")
    }
    
    open func webViewController() -> WebViewController! {
        return storyboard.instantiateViewController(withIdentifier: "webViewController") as? WebViewController
    }
}

import CoreLocation
@objc
open class WakupOptions: NSObject {
    open var iconLibrary: IconLibrary = DefaultIconLibrary()
    
    /// Default user location, used when there's no user location available
    open var defaultLocation = CLLocation(latitude: 40.416944, longitude: -3.703611) // Puerta del Sol, Madrid
    
    /// Search country, will be appended to geolocation searches to narrow results
    open var searchCountryCode: String? = "es" // NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String
    
    /// Category definition. Used for search controller shortcuts. Set to nil to disable category search.
    open var searchCategories: [OfferCategory]? = [
        OfferCategory(title: "Comida", icon: "restaurant", associatedTags: ["restaurants"]),
        OfferCategory(title: "Tiendas", icon: "shopping", associatedTags: ["shopping"]),
        OfferCategory(title: "Ocio", icon: "leisure", associatedTags: ["leisure"]),
        OfferCategory(title: "Servicios", icon: "services", associatedTags: ["services"])
    ]
    
    public override init() {}
}
