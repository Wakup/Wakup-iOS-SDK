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
    
    public dynamic var labelFont: UIFont? { get { return label?.font } set { label?.font = newValue } }
    public dynamic var labelColor: UIColor? { get { return label?.textColor } set { label?.textColor = newValue } }
}