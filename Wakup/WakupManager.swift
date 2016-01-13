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

public class WakupOptions {
    public var iconLibrary: IconLibrary = DefaultIconLibrary()
    
    public init() {}
}