//
//  Company.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 30/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation

open class Company {
    public let id: Int
    public let name: String
    public let logo: CouponImage?
    
    public init(id: Int, name: String, logo: CouponImage?) {
        self.id = id
        self.name = name
        self.logo = logo
    }
}
