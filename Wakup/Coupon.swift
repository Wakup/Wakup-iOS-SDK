//
//  Coupon.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation

open class Coupon: Equatable {
    open let id: Int
    open let shortText: String
    open let shortDescription: String
    open let description: String
    open let tags: [String]
    open let expirationDate: Date?
    open let thumbnail, image: CouponImage?
    open let store: Store?
    open let company: Company
    open let online: Bool
    open let link: URL?
    open var redemptionCode: RedemptionCodeInfo?
    
    public init(id: Int, shortText: String, shortDescription: String, description: String, tags: [String], online: Bool, link: URL?, expirationDate: Date?, thumbnail: CouponImage?, image: CouponImage?, store: Store?, company: Company, redemptionCode: RedemptionCodeInfo?) {
        self.id = id
        self.shortText = shortText
        self.shortDescription = shortDescription
        self.description = description
        self.tags = tags
        self.online = online
        self.link = link
        self.expirationDate = expirationDate
        self.thumbnail = thumbnail
        self.image = image
        self.store = store
        self.company = company
        self.redemptionCode = redemptionCode
    }
}

public func ==(lhs: Coupon, rhs: Coupon) -> Bool {
    return lhs.id == rhs.id
}
