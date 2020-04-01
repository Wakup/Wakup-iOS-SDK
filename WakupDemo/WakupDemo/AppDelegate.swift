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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupCustomFonts()
        
        WakupManager.manager.setup("075f9656-6909-4e4e-a286-3ddc562a2513")  // Sample project API Key, don't use this in a production environment	
        //WakupManager.appearance.setTint(mainColor: UIColor(fromHexString: "#5788a9"))
        
        // Sample of offer carousel view with modal integration
        //window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        
        // Sample of direct integration as root controller
        window?.rootViewController = WakupManager.manager.rootNavigationController()
        
        window?.makeKeyAndVisible()
        
        return true
    }

    
    func setupCustomFonts() {
        CategoryFilterButton.appearance().titleFont = UIFont(name: "Aller-Bold", size: 14)
        SearchFilterButton.appearance().titleFont = UIFont(name: "Aller", size: 10)
        
        CouponCollectionViewCell.appearance().storeNameFont = UIFont(name: "Aller-Bold", size: 17)
        CouponCollectionViewCell.appearance().descriptionTextFont = UIFont(name: "Aller-Italic", size: 15)
        CouponCollectionViewCell.appearance().distanceFont = UIFont(name: "Aller-Italic", size: 11)
        CouponCollectionViewCell.appearance().expirationFont = UIFont(name: "Aller-Italic", size: 11)
        DiscountTagView.appearance().labelFont = UIFont(name: "AllerDisplay", size: 17)
        
        CouponActionButton.appearance().titleFont = UIFont(name: "Aller", size: 10)
        CouponDetailHeaderView.appearance().companyNameFont = UIFont(name: "Aller", size: 18)
        CouponDetailHeaderView.appearance().storeAddressFont = UIFont(name: "Aller-LightItalic", size: 14)
        CouponDetailHeaderView.appearance().storeDistanceFont = UIFont(name: "Aller-Italic", size: 11)
        CouponDetailHeaderView.appearance().couponNameFont = UIFont(name: "Aller", size: 19)
        CouponDetailHeaderView.appearance().couponDescriptionFont = UIFont(name: "Aller", size: 14)
        CouponDetailHeaderView.appearance().expirationFont = UIFont(name: "Aller-Italic", size: 13)
        
        if #available(iOS 9.0, *) {
            let headerTitle = UILabel.appearance(whenContainedInInstancesOf:[UITableViewHeaderFooterView.self])
            headerTitle.font = UIFont(name: "Aller", size: 16)
            
            let searchBarTextField = UITextField.appearance(whenContainedInInstancesOf:[UISearchBar.self])
            searchBarTextField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([
                NSAttributedString.Key.font.rawValue: UIFont(name: "Aller", size: 14)!
            ])
        }
    }
}

// Required to set title font 
extension UIButton {
    var titleFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
