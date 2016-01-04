//
//  CodeIconButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 11/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CodeIconButton: CustomBorderButton {
    
    @IBInspectable var iconIdentifier: String? { didSet { refreshIcons() } }
    @IBInspectable var iconColor: UIColor? { didSet { refreshNormal() } }
    @IBInspectable var highlightedIconColor: UIColor? { didSet { refreshHighlighted() } }
    @IBInspectable var selectedIconColor: UIColor? { didSet { refreshSelected() } }
    @IBInspectable var disabledIconColor: UIColor? { didSet { refreshDisabled() } }
    @IBInspectable var highlightedSelectedIconColor: UIColor? { didSet { refreshHighlightedSelected() } }
    @IBInspectable var highlightedDisabledIconColor: UIColor? { didSet { refreshHighlightedDisabled() } }
    @IBInspectable var iconSize: CGSize = CGSize(width: 20, height: 20) { didSet { refreshIcons() } }
    @IBInspectable var iconFillsButton: Bool = false { didSet { refreshIcons() } }
    
    private var codeIcon: CodeIcon?
    private var iconFrame: CGRect { get { return iconFillsButton ? bounds : CGRect(origin: CGPointZero, size: iconSize) } }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func refreshIcons() {
        codeIcon = CodeIcon(iconIdentifier: iconIdentifier ?? "")
        refreshNormal()
        refreshHighlighted()
        refreshSelected()
        refreshDisabled()
        refreshHighlightedDisabled()
        refreshHighlightedDisabled()
    }
    
    func refreshNormal() {
        setImage(getIcon(color: iconColor), forState: .Normal)
    }
    
    func refreshHighlighted() {
        setImage(getIcon(color: highlightedIconColor), forState: .Highlighted)
    }
    
    func refreshSelected() {
        setImage(getIcon(color: selectedIconColor), forState: .Selected)
    }
    
    func refreshDisabled() {
        setImage(getIcon(color: disabledIconColor), forState: .Disabled)
    }
    
    func refreshHighlightedSelected() {
        if let color = highlightedSelectedIconColor {
            setImage(getIcon(color: color), forState: [.Selected, .Highlighted])
        }
    }
    
    func refreshHighlightedDisabled() {
        if let color = highlightedDisabledIconColor {
            setImage(getIcon(color: color), forState: [.Disabled, .Highlighted])
        }
    }
    
    func getIcon(color color: UIColor?) -> UIImage? {
        return codeIcon?.getImage(iconFrame, color: color)
    }
    
}