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
    
    internal var config = WakupConfiguration()
    
    public func setup(apiKey: String, config: WakupConfiguration = WakupConfiguration()) {
        SearchService.sharedInstance.apiKey = apiKey
        OffersService.apiKey = apiKey
        
        self.config = config
        CodeIconLibrary.instance = config.iconLibrary
    }
    
    public lazy var storyboard: UIStoryboard! = UIStoryboard(name: "Wakup", bundle: NSBundle(forClass: WakupManager.self))
    
    public func initialController() -> UIViewController! {
        return storyboard.instantiateInitialViewController()
    }
}

public class WakupConfiguration {
    public var iconLibrary: IconLibrary = MyIconLibrary()
    
    public init() {}
}