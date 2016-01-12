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

        // Customization sample
//        let corporateColor = UIColor(red:0.98, green:0.16, blue:0.63, alpha:1)
//        let darkCorporateColor = UIColor(red:0.85, green:0, blue:0.47, alpha:1)
//        let navBarTintColor = UIColor.whiteColor()
//        let couponTextColor = UIColor(red:0, green:0.56, blue:0.13, alpha:1)
//        
//        // Navigation bar appearance
//        UINavigationBar.appearance().barTintColor = corporateColor
//        UINavigationBar.appearance().tintColor = navBarTintColor
//        UINavigationBar.appearance().titleTextAttributes = [
//            NSForegroundColorAttributeName: navBarTintColor
//        ]
//        NavBarIconButton.appearance().iconColor = navBarTintColor
//        NavBarIconButton.appearance().highlightedIconColor = navBarTintColor.colorWithAlphaComponent(0.5)
//        NavBarIconView.appearance().iconColor = navBarTintColor
//        
//        // Top Menu Appearance
//        TopMenuButton.appearance().setTitleColor(UIColor.blackColor(), forState: .Normal)
//        TopMenuButton.appearance().setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
//        TopMenuButton.appearance().iconIdentifier = nil // Remove icons from menu buttons
//        TopMenuButton.appearance().titleEdgeInsets = UIEdgeInsetsZero
//        TopMenuButton.appearance().imageEdgeInsets = UIEdgeInsetsZero
//        TopMenuButton.appearance().backgroundColor = UIColor.clearColor()
//        TopMenuButton.appearance().highlightedBackgroundColor = UIColor.clearColor()
//        TopMenuView.appearance().backgroundColor = darkCorporateColor
//        
//        // Contextual menu
//        ContextItemView.appearance().backgroundColor = darkCorporateColor
//        ContextItemView.appearance().highlightedBackgroundColor = corporateColor
//        
//        // Coupon collection cells
//        CouponCollectionViewCell.appearance().storeNameTextColor = couponTextColor
//        CouponCollectionViewCell.appearance().descriptionTextColor = couponTextColor
//        CouponCollectionViewCell.appearance().distanceTextColor = couponTextColor
//        CouponCollectionViewCell.appearance().distanceIconColor = couponTextColor
//        CouponCollectionViewCell.appearance().expirationTextColor = couponTextColor
//        CouponCollectionViewCell.appearance().expirationIconColor = couponTextColor
//        
//        // Coupon details
//        CouponDetailHeaderView.appearance().companyNameTextColor = couponTextColor
//        CouponDetailHeaderView.appearance().storeAddressTextColor = couponTextColor
//        CouponDetailHeaderView.appearance().storeDistanceTextColor = couponTextColor
//        CouponDetailHeaderView.appearance().storeDistanceIconColor = couponTextColor
//        CouponDetailHeaderView.appearance().couponNameTextColor = couponTextColor
//        CouponDetailHeaderView.appearance().couponDescriptionTextColor = couponTextColor
//        CouponDetailHeaderView.appearance().shortTextColor = couponTextColor
//        CouponDetailHeaderView.appearance().expirationTextColor = couponTextColor
//        CouponDetailHeaderView.appearance().expirationIconColor = couponTextColor
//        CouponDetailHeaderView.appearance().companyDisclosureColor = couponTextColor
//        CouponDetailHeaderView.appearance().couponDescriptionDisclosureColor = couponTextColor
//        CouponDetailHeaderView.appearance().companyNameTextColor = couponTextColor
//        
//        CouponActionButton.appearance().iconColor = darkCorporateColor
//        CouponActionButton.appearance().highlightedBackgroundColor = darkCorporateColor
//        CouponActionButton.appearance().setTitleColor(darkCorporateColor, forState: .Normal)
//        CouponActionButton.appearance().normalBorderColor = darkCorporateColor
//        
//        DiscountTagView.appearance().backgroundColor = UIColor(red:0.88, green:0.94, blue:0.88, alpha:1)
//        DiscountTagView.appearance().labelColor = couponTextColor
//        
//        // Search view
//        SearchFilterButton.appearance().iconColor = darkCorporateColor
//        SearchFilterButton.appearance().highlightedBackgroundColor = darkCorporateColor
//        SearchFilterButton.appearance().setTitleColor(darkCorporateColor, forState: .Normal)
//        SearchFilterButton.appearance().normalBorderColor = darkCorporateColor
//        
//        SearchResultCell.appearance().iconColor = darkCorporateColor
//        
//        // Map View
//        CouponAnnotationView.appearance().restaurantCategoryColor = UIColor.redColor()
//        CouponAnnotationView.appearance().leisureCategoryColor = UIColor.greenColor()
//        CouponAnnotationView.appearance().servicesCategoryColor = UIColor.blueColor()
//        CouponAnnotationView.appearance().shoppingCategoryColor = UIColor.orangeColor()
        
        
        let wakupConfig = WakupConfiguration()
        WakupManager.manager.setup("YOUR WAKUP API KEY HERE", config: wakupConfig)
        window?.rootViewController = WakupManager.manager.rootNavigationController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

