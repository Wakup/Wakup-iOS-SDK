//
//  CodeIconView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 31/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class CodeIconView: UIView, Highlightable {
    
    @IBInspectable public dynamic var iconColor: UIColor? { didSet { setNeedsDisplay() } }
    @IBInspectable public dynamic var highlightedIconColor: UIColor? { didSet { setNeedsDisplay() } }
    @IBInspectable public var highlighted: Bool = false { didSet { setNeedsDisplay() } }
    
    @IBInspectable public dynamic var iconIdentifier: String = "" { didSet { codeIcon = CodeIcon(iconIdentifier: iconIdentifier) } }
    
    var codeIcon: CodeIcon? { didSet { setNeedsDisplay() } }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let color = highlighted && highlightedIconColor != nil ? highlightedIconColor! : iconColor
        codeIcon?.draw(bounds, color: color)
    }
}