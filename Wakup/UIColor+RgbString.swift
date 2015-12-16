//
//  UIColor+RgbString.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 19/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(fromHexString hex: String) {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if (cString.characters.count == 6) {
            var rgbValue:UInt32 = 0
            NSScanner(string: cString).scanHexInt(&rgbValue)
            
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        else {
            self.init(white: 0.5, alpha: 1.0)
        }
    }
}