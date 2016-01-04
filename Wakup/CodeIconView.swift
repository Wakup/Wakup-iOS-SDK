//
//  CodeIconView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 31/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CodeIconView: UIView, Highlightable {
    
    @IBInspectable var iconColor: UIColor? { didSet { setNeedsDisplay() } }
    @IBInspectable var highlightedIconColor: UIColor? { didSet { setNeedsDisplay() } }
    @IBInspectable var highlighted: Bool = false { didSet { setNeedsDisplay() } }
    
    @IBInspectable var iconIdentifier: String = "" { didSet { codeIcon = CodeIcon(iconIdentifier: iconIdentifier) } }
    
    var codeIcon: CodeIcon? { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let color = highlighted && highlightedIconColor != nil ? highlightedIconColor! : iconColor
        codeIcon?.draw(bounds, color: color)
    }
}