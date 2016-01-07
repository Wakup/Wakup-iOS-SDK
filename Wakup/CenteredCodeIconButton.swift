//
//  CenteredCodeIconButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class CenteredCodeIconButton: CodeIconButton {
    @IBInspectable dynamic public var padding: CGFloat = 6
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        centerVerticallyWithPadding(padding)
    }
}