//
//  Company.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 30/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation

open class Company {
    open let id: Int
    open let name: String
    open let logo: CouponImage?
    
    public init(id: Int, name: String, logo: CouponImage?) {
        self.id = id
        self.name = name
        self.logo = logo
    }
}
