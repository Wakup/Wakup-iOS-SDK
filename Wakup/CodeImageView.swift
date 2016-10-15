//
//  CodeImageView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 18/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CodeImageView: UIView {
    var codeImage: CodeImage? { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        codeImage?.draw(bounds)
    }
}
