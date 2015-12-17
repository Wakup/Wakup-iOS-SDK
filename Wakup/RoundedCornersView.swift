//
//  RoundedCornersView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 30/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set(cornerRadius) {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let borderColor = self.layer.borderColor {
                return UIColor(CGColor: borderColor)
            }
            return .None
        }
        set {
            if let color = newValue {
                self.layer.borderColor = color.CGColor
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set(borderWidth) {
            self.layer.borderWidth = borderWidth
        }
    }
}

@IBDesignable class RoundedCornerView: UIView {
}
