//
//  CouponImage.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

open class CouponImage {
    public let sourceUrl: URL
    public let width, height: Float
    public let color: UIColor
    
    public init(sourceUrl: URL, width: Float, height: Float, color: UIColor) {
        self.sourceUrl = sourceUrl
        self.width = width
        self.height = height
        self.color = color
    }
}
