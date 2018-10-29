//
//  WakupTagListView.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 15/12/17.
//  Copyright © 2017 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit
import TagListView

class WakupTagListView: TagListView {
    @IBInspectable open dynamic var wakupCornerRadius: CGFloat {
        get { return (self as RoundedCorners).cornerRadius }
        set { var r = (self as RoundedCorners); r.cornerRadius = newValue }
    }
    @IBInspectable open dynamic var wakupBorderWidth: CGFloat {
        get { return (self as RoundedCorners).borderWidth }
        set { var r = (self as RoundedCorners); r.borderWidth = newValue }
    }
    
    @IBInspectable open dynamic var wakupBorderColor: UIColor? {
        get { return (self as RoundedCorners).borderColor }
        set { var r = (self as RoundedCorners); r.borderColor = newValue }
    }
    
    @IBInspectable open dynamic var wakupSelectedBorderColor: UIColor? {
        get { return selectedBorderColor }
        set { selectedBorderColor = newValue }
    }
    
}
