//
//  ContextItemView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 19/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit

@IBDesignable open class ContextItemView: UIView {

    @IBInspectable open dynamic var iconColor: UIColor? { get { return codeIconView?.iconColor } set { codeIconView?.iconColor = newValue } }
    @IBInspectable open dynamic var highlightedIconColor: UIColor?
    @IBInspectable open dynamic var highlightedBackgroundColor: UIColor?
    
    var iconIdentifier: String? { get { return codeIconView?.iconIdentifier } set(value) { codeIconView?.iconIdentifier = value ?? "" } }
    
    var highlighted = false
    
    @IBOutlet weak var codeIconView: CodeIconView!
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if highlighted {
            iconColor = highlightedIconColor ?? iconColor
            backgroundColor = highlightedBackgroundColor ?? backgroundColor
        }
    }
}
