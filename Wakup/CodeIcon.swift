//
//  CodeIcon.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 09/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

public typealias IconDrawMethod = (_ frame: CGRect, _ color: UIColor) -> Void

open class CodeIcon {
    
    let drawMethod: IconDrawMethod
    let aspectRatio: CGFloat
    let defaultColor: UIColor
    
    public init(drawMethod: @escaping IconDrawMethod, defaultColor: UIColor, aspectRatio: CGFloat) {
        self.drawMethod = drawMethod
        self.defaultColor = defaultColor
        self.aspectRatio = aspectRatio
    }
    
    public convenience init(iconIdentifier: String) {
        let (drawMethod, aspectRatio) = CodeIconLibrary.drawMethodForIcon(iconIdentifier: iconIdentifier)
        let defaultColor = CodeIconLibrary.getDefaultColor(iconIdentifier: iconIdentifier)
        self.init(drawMethod: drawMethod, defaultColor: defaultColor, aspectRatio: aspectRatio)
    }
    
    open func draw(_ frame: CGRect, color: UIColor? = nil) {
        getCodeImage(forColor: color ?? defaultColor).draw(frame)
    }
    
    open func getImage(_ frame: CGRect, color: UIColor? = nil) -> UIImage {
        return getCodeImage(forColor: color ?? defaultColor).getImage(frame)
    }
    
    open func getCodeImage(forColor color: UIColor? = nil) -> CodeImage {
        return CodeImage(drawMethod: { frame in self.drawMethod(frame, color ?? self.defaultColor) }, aspectRatio: self.aspectRatio)
    }
}
