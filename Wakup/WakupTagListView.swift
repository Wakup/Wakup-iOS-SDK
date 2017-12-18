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
        get { return cornerRadius }
        set { cornerRadius = newValue }
    }
    @IBInspectable open dynamic var wakupBorderWidth: CGFloat {
        get { return borderWidth }
        set { borderWidth = newValue }
    }
    
    @IBInspectable open dynamic var wakupBorderColor: UIColor? {
        get { return borderColor }
        set { borderColor = newValue }
    }
    
    @IBInspectable open dynamic var wakupSelectedBorderColor: UIColor? {
        get { return selectedBorderColor }
        set { selectedBorderColor = newValue }
    }
    
}
