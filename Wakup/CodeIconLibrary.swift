//
//  CodeIconLibrary.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 31/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

public protocol IconLibrary {
    func drawMethodForIcon(iconIdentifier iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat)
    func getDefaultColor(iconIdentifier iconIdentifier: String) -> UIColor
}

public class CodeIconLibrary {
    
    #if TARGET_INTERFACE_BUILDER
    public static var instance: IconLibrary? = MyIconLibrary()
    #else
    public static var instance: IconLibrary?
    #endif
    
    public class func drawMethodForIcon(iconIdentifier iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat)  {
        guard let instance = instance else { return ({ f, c in }, 1) }
        return instance.drawMethodForIcon(iconIdentifier: iconIdentifier)
    }
    
    public class func getDefaultColor(iconIdentifier iconIdentifier: String) -> UIColor {
        guard let instance = instance else { return UIColor.darkGrayColor() }
        return instance.getDefaultColor(iconIdentifier: iconIdentifier)
    }
}