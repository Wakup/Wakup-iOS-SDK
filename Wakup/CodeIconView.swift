//
//  CodeIconView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 31/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class CodeIconView: UIView, Highlightable {
    
    @IBInspectable open dynamic var iconColor: UIColor? { didSet { setNeedsDisplay() } }
    @IBInspectable open dynamic var highlightedIconColor: UIColor? { didSet { setNeedsDisplay() } }
    @IBInspectable open var isHighlighted: Bool = false { didSet { setNeedsDisplay() } }
    
    @IBInspectable open dynamic var iconIdentifier: String = "" { didSet { codeIcon = CodeIcon(iconIdentifier: iconIdentifier) } }
    
    var codeIcon: CodeIcon? { didSet { setNeedsDisplay() } }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let color = isHighlighted && highlightedIconColor != nil ? highlightedIconColor! : iconColor
        codeIcon?.draw(bounds, color: color)
    }
}
