//
//  CenteredCodeIconButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CenteredCodeIconButton: CodeIconButton {
    @IBInspectable var padding: CGFloat = 6
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerVerticallyWithPadding(padding)
    }
}