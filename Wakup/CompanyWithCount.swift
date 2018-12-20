//
//  CompanyWithCount.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 14/12/18.
//  Copyright © 2018 Yellow Pineapple. All rights reserved.
//

import Foundation

open class CompanyWithCount: Company {
    public let offerCount: Int
    
    public init(id: Int, name: String, logo: CouponImage?, offerCount: Int) {
        self.offerCount = offerCount
        super.init(id: id, name: name, logo: logo)
    }
}


extension CompanyWithCount: Equatable, Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

public func ==(lhs: CompanyWithCount, rhs: CompanyWithCount) -> Bool {
    return lhs.id == rhs.id
}
