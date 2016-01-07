//
//  CustomBorderButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

@IBDesignable public class CustomBorderButton: CustomBackgroundButton {
    @IBInspectable public dynamic var normalBorderColor: UIColor?
    @IBInspectable public dynamic var selectedBorderColor: UIColor?
    @IBInspectable public dynamic var highlightedBorderColor: UIColor?
    @IBInspectable public dynamic var disabledBorderColor: UIColor?
    @IBInspectable public dynamic var highlightedDisabledBorderColor: UIColor?
    @IBInspectable public dynamic var highlightedSelectedBorderColor: UIColor?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func refreshUI() {
        super.refreshUI()
        self.borderColor = getCurrentBorderColor() ?? normalBorderColor
    }
    
    func getCurrentBorderColor() -> UIColor? {
        switch (enabled, highlighted, selected) {
        case (false, true, _): return highlightedDisabledBorderColor ?? disabledBorderColor
        case (false, false, _): return disabledBorderColor ?? normalBorderColor?.colorWithAlpha(0.5)
        case (true, false, false): return normalBorderColor
        case (true, true, true): return highlightedSelectedBorderColor ?? highlightedBorderColor
        case (true, true, false): return highlightedBorderColor
        case (true, false, true): return selectedBorderColor ?? highlightedBorderColor
        }
    }
}