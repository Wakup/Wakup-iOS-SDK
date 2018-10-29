//
//  RoundedCornersView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 30/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import UIKit

protocol RoundedCorners {
    var cornerRadius: CGFloat { get set }
    var borderColor: UIColor? { get set }
    var borderWidth: CGFloat { get set }
}

extension UIView: RoundedCorners {
    
    @IBInspectable public dynamic var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set(cornerRadius) {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public dynamic var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            if let color = newValue {
                self.layer.borderColor = color.cgColor
            }
        }
    }
    
    @IBInspectable public dynamic var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set(borderWidth) {
            self.layer.borderWidth = borderWidth
        }
    }
}

@IBDesignable class RoundedCornerView: UIView {
}
