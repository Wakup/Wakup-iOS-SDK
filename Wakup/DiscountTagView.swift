//
//  DiscountTagView.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 7/1/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

@IBDesignable
public class DiscountTagView: UIView {
    
    @IBOutlet var label: UILabel?
    
    public dynamic var labelFont: UIFont?
    public dynamic var labelColor: UIColor?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let label = label else { return }
        
        if let labelFont = labelFont {
            label.font = labelFont
        }
        if let labelColor = labelColor {
            label.textColor = labelColor
        }
        
    }
}