//
//  WakupManager.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 17/12/15.
//  Copyright © 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

public class WakupManager {
    public static let manager = WakupManager()
    
    internal var options = WakupOptions()
    
    public func setup(apiKey: String, options: WakupOptions = WakupOptions()) {
        SearchService.sharedInstance.apiKey = apiKey
        OffersService.apiKey = apiKey
        
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
}

import CoreLocation
public class WakupOptions {
    public var iconLibrary: IconLibrary = DefaultIconLibrary()
    
    /// Default user location, used when there's no user location available
    public var defaultLocation = CLLocation(latitude: 40.416944, longitude: -3.703611) // Puerta del Sol, Madrid
    
    /// Search country, will be appended to geolocation searches to narrow results
    public var searchCountryCode: String? = "es" // NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String
    
    public init() {}
}