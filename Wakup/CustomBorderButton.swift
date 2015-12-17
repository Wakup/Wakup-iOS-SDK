//
//  CustomBorderButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

@IBDesignable class CustomBorderButton: CustomBackgroundButton {
    @IBInspectable var selectedBorderColor: UIColor?
    @IBInspectable var highlightedBorderColor: UIColor?
    @IBInspectable var disabledBorderColor: UIColor?
    @IBInspectable var highlightedDisabledBorderColor: UIColor?
    @IBInspectable var highlightedSelectedBorderColor: UIColor?
    var originalBorderColor: UIColor?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func refreshUI() {
        super.refreshUI()
        if originalBorderColor == nil && borderColor == nil {
            return
        }
        
        if originalBorderColor == nil {
            originalBorderColor = self.borderColor
        }
        self.borderColor = getCurrentBorderColor() ?? originalBorderColor
    }
    
    func getCurrentBorderColor() -> UIColor? {
        switch (enabled, highlighted, selected) {
        case (false, true, _): return highlightedDisabledBorderColor ?? disabledBorderColor
        case (false, false, _): return disabledBorderColor ?? originalBorderColor?.colorWithAlpha(0.5)
        case (true, true, true): return highlightedSelectedBorderColor ?? highlightedBorderColor
        case (true, true, false): return highlightedBorderColor
        case (true, false, true): return selectedBorderColor ?? highlightedBorderColor
        default: return .None
        }
    }
}