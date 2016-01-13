//
//  AppDelegate.swift
//  WakupDemo
//
//  Created by Guillermo Gutiérrez on 17/12/15.
//  Copyright © 2015 Yellow Pineapple. All rights reserved.
//

import UIKit
import Wakup

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        WakupManager.manager.setup("YOUR WAKUP API KEY HERE")
        window?.rootViewController = WakupManager.manager.rootNavigationController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

