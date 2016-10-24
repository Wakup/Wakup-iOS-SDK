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

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        WakupManager.manager.setup("1223b89c-ca0b-4c40-bc87-6fce7f7d1ad7")  // Sample project API Key, don't use this in a production environment
        window?.rootViewController = WakupManager.manager.rootNavigationController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

