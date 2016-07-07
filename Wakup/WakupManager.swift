//
//  WakupManager.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 17/12/15.
//  Copyright © 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

@objc
public class WakupManager: NSObject {
    public static let manager = WakupManager()
    
    internal var options = WakupOptions()
    
    public func setup(apiKey: String, options: WakupOptions = WakupOptions()) {
        SearchService.sharedInstance.apiKey = apiKey
        OffersService.sharedInstance.apiKey = apiKey
        UserService.sharedInstance.apiKey = apiKey
        
        self.options = options
        CodeIconLibrary.instance = options.iconLibrary
    }
    
    public lazy var storyboard: UIStoryboard! = UIStoryboard(name: "Wakup", bundle: NSBundle(forClass: WakupManager.self))
    
    public func rootNavigationController() -> UINavigationController! {
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    public func rootController() -> UIViewController! {
        return storyboard.instantiateViewControllerWithIdentifier("couponWaterfall")
    }
    
    public func webViewController() -> WebViewController! {
        return storyboard.instantiateViewControllerWithIdentifier("webViewController") as? WebViewController
    }
}

import CoreLocation
@objc
public class WakupOptions: NSObject {
    public var iconLibrary: IconLibrary = DefaultIconLibrary()
    
    /// Default user location, used when there's no user location available
    public var defaultLocation = CLLocation(latitude: 40.416944, longitude: -3.703611) // Puerta del Sol, Madrid
    
    /// Search country, will be appended to geolocation searches to narrow results
    public var searchCountryCode: String? = "es" // NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String
    
    /// Category definition. Used for search controller shortcuts. Set to nil to disable category search.
    public var searchCategories: [OfferCategory]? = [
        OfferCategory(title: "Comida", icon: "restaurant", associatedTags: ["restaurants"]),
        OfferCategory(title: "Tiendas", icon: "shopping", associatedTags: ["shopping"]),
        OfferCategory(title: "Ocio", icon: "leisure", associatedTags: ["leisure"]),
        OfferCategory(title: "Servicios", icon: "services", associatedTags: ["services"])
    ]
    
    public override init() {}
}