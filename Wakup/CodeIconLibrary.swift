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

public class CodeIconLibrary {
    
    #if TARGET_INTERFACE_BUILDER
    public static var instance: IconLibrary? = DefaultIconLibrary()
    #else
    public static var instance: IconLibrary?
    #endif
    
    public class func drawMethodForIcon(iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat)  {
        guard let instance = instance else { return ({ f, c in }, 1) }
        return instance.drawMethodForIcon(iconIdentifier: iconIdentifier)
    }
    
    public class func getDefaultColor(iconIdentifier: String) -> UIColor {
        guard let instance = instance else { return UIColor.darkGray }
        return instance.getDefaultColor(iconIdentifier: iconIdentifier)
    }
    
    /** Creates a draw method for the specified image, allowing it to be used instead of vector icons */
    public class func drawMethodForImage(_ image: UIImage, tinted: Bool = true) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat) {
        let aspectRatio = image.size.width / image.size.height;
        let drawMethod: IconDrawMethod = { (frame, color) in
            let tintedImage = image.withRenderingMode(tinted ? .alwaysTemplate : .alwaysOriginal)
            color.set()
            tintedImage.draw(in: frame)
        }
        return (drawMethod: drawMethod, aspectRatio: aspectRatio)
    }
}
