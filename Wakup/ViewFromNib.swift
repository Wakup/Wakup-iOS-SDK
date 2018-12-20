//
//  UIView+FromNib.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 11/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

class CurrentBundle {
    static func currentBundle() -> Bundle {
        return Bundle(for: self)
    }
}

func loadViewFromNib(_ nibName: String) -> UIView! {
    return CurrentBundle.currentBundle().loadNibNamed(nibName, owner: nil, options: nil)![0] as? UIView
}
