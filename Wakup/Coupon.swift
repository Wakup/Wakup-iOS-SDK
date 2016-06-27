//
//  Coupon.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation

public class Coupon: Equatable {
    public let id: Int
    public let shortText: String
    public let shortDescription: String
    public let description: String
    public let tags: [String]
    public let expirationDate: NSDate?
    public let thumbnail, image: CouponImage?
    public let store: Store?
    public let company: Company
    public let online: Bool
    public let link: NSURL?
    public let redemptionCode: RedemptionCodeInfo?
    
    public init(id: Int, shortText: String, shortDescription: String, description: String, tags: [String], online: Bool, link: NSURL?, expirationDate: NSDate?, thumbnail: CouponImage?, image: CouponImage?, store: Store?, company: Company, redemptionCode: RedemptionCodeInfo?) {
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