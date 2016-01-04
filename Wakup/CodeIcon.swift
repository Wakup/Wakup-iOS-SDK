//
//  CodeIcon.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 09/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

public typealias IconDrawMethod = (frame: CGRect, color: UIColor) -> Void

public class CodeIcon {
    
    let drawMethod: IconDrawMethod
    let aspectRatio: CGFloat
    let defaultColor: UIColor
    
    public init(drawMethod: IconDrawMethod, defaultColor: UIColor, aspectRatio: CGFloat) {
        self.drawMethod = drawMethod
        self.defaultColor = defaultColor
        self.aspectRatio = aspectRatio
    }
    
    public convenience init(iconIdentifier: String) {
        let (drawMethod, aspectRatio) = CodeIconLibrary.drawMethodForIcon(iconIdentifier: iconIdentifier)
        let defaultColor = CodeIconLibrary.getDefaultColor(iconIdentifier: iconIdentifier)
        self.init(drawMethod: drawMethod, defaultColor: defaultColor, aspectRatio: aspectRatio)
    }
    
    public func draw(frame: CGRect, color: UIColor? = nil) {
        getCodeImage(forColor: color ?? defaultColor).draw(frame)
    }
    
    public func getImage(frame: CGRect, color: UIColor? = nil) -> UIImage {
        return getCodeImage(forColor: color ?? defaultColor).getImage(frame)
    }
    
    public func getCodeImage(forColor color: UIColor? = nil) -> CodeImage {
        return CodeImage(drawMethod: { frame in self.drawMethod(frame: frame, color: color ?? self.defaultColor) }, aspectRatio: self.aspectRatio)
    }
}