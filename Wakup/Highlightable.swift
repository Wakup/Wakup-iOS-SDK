//
//  Highlightable.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 25/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

protocol Highlightable {
     var highlighted: Bool { get set }
}

class HUILabel: UILabel, Highlightable {
    
}