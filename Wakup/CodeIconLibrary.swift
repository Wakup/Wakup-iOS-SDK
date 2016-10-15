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
    func drawMethodForIcon(iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat)
    func getDefaultColor(iconIdentifier: String) -> UIColor
}

open class CodeIconLibrary {
    
    #if TARGET_INTERFACE_BUILDER
    public static var instance: IconLibrary? = DefaultIconLibrary()
    #else
    open static var instance: IconLibrary?
    #endif
    
    open class func drawMethodForIcon(iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat)  {
        guard let instance = instance else { return ({ f, c in }, 1) }
        return instance.drawMethodForIcon(iconIdentifier: iconIdentifier)
    }
    
    open class func getDefaultColor(iconIdentifier: String) -> UIColor {
        guard let instance = instance else { return UIColor.darkGray }
        return instance.getDefaultColor(iconIdentifier: iconIdentifier)
    }
}
