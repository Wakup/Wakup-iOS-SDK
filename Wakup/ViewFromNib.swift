//
//  UIView+FromNib.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 11/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

func loadViewFromNib(nibName: String) -> UIView! {
    return NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil)[0] as! UIView
}