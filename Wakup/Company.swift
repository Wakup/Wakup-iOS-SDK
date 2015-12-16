//
//  Company.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 30/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation

class Company {
    let id: Int
    let name: String
    let logo: CouponImage?
    
    init(id: Int, name: String, logo: CouponImage?) {
        self.id = id
        self.name = name
        self.logo = logo
    }
}