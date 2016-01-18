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

    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        WakupManager.manager.setup("075f9656-6909-4e4e-a286-3ddc562a2513")  // Sample project API Key, don't use this in a production environment
        window?.rootViewController = WakupManager.manager.rootNavigationController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

