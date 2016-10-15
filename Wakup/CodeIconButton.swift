//
//  CodeIconButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 11/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class CodeIconButton: CustomBorderButton {
    
    @IBInspectable open dynamic var iconIdentifier: String? { didSet { refreshIcons() } }
    @IBInspectable open dynamic var iconColor: UIColor? { didSet { refreshNormal() } }
    @IBInspectable open dynamic var highlightedIconColor: UIColor? { didSet { refreshHighlighted() } }
    @IBInspectable open dynamic var selectedIconColor: UIColor? { didSet { refreshSelected() } }
    @IBInspectable open dynamic var disabledIconColor: UIColor? { didSet { refreshDisabled() } }
    @IBInspectable open dynamic var highlightedSelectedIconColor: UIColor? { didSet { refreshHighlightedSelected() } }
    @IBInspectable open dynamic var highlightedDisabledIconColor: UIColor? { didSet { refreshHighlightedDisabled() } }
    @IBInspectable open dynamic var iconSize: CGSize = CGSize(width: 20, height: 20) { didSet { refreshIcons() } }
    @IBInspectable open dynamic var iconFillsButton: Bool = false { didSet { refreshIcons() } }
    
    fileprivate var codeIcon: CodeIcon?
    fileprivate var iconFrame: CGRect { get { return iconFillsButton ? bounds : CGRect(origin: CGPoint.zero, size: iconSize) } }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func refreshIcons() {
        codeIcon = iconIdentifier.map { CodeIcon(iconIdentifier: $0) }
        refreshNormal()
        refreshHighlighted()
        refreshSelected()
        refreshDisabled()
        refreshHighlightedDisabled()
        refreshHighlightedDisabled()
    }
    
    func refreshNormal() {
        setImage(getIcon(color: iconColor), for: UIControlState())
    }
    
    func refreshHighlighted() {
        setImage(getIcon(color: highlightedIconColor), for: .highlighted)
    }
    
    func refreshSelected() {
        setImage(getIcon(color: selectedIconColor), for: .selected)
    }
    
    func refreshDisabled() {
        setImage(getIcon(color: disabledIconColor), for: .disabled)
    }
    
    func refreshHighlightedSelected() {
        if let color = highlightedSelectedIconColor {
            setImage(getIcon(color: color), for: [.selected, .highlighted])
        }
    }
    
    func refreshHighlightedDisabled() {
        if let color = highlightedDisabledIconColor {
            setImage(getIcon(color: color), for: [.disabled, .highlighted])
        }
    }
    
    func getIcon(color: UIColor?) -> UIImage? {
        return codeIcon?.getImage(iconFrame, color: color)
    }
    
}
