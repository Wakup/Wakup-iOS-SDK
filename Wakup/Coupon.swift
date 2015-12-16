//
//  Coupon.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation

enum Category {
    case Restaurant
    case Leisure
    case Shopping
    case Services
    case Other
}

class Coupon: Equatable {
    let id: Int
    let shortText: String
    let shortDescription: String
    let description: String
    let expirationDate: NSDate?
    let thumbnail, image: CouponImage?
    let category: Category
    let store: Store?
    let company: Company
    let online: Bool
    
    init(id: Int, shortText: String, shortDescription: String, description: String, category: Category, online: Bool, expirationDate: NSDate?, thumbnail: CouponImage?, image: CouponImage?, store: Store?, company: Company) {
        self.id = id
        self.shortText = shortText
        self.shortDescription = shortDescription
        self.description = description
        self.category = category
        self.online = online
        self.expirationDate = expirationDate
        self.thumbnail = thumbnail
        self.image = image
        self.store = store
        self.company = company
    }
}

func ==(lhs: Coupon, rhs: Coupon) -> Bool {
    return lhs.id == rhs.id
}