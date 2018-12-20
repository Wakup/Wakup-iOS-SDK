//
//  CompanyCategory.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 14/12/18.
//  Copyright © 2018 Yellow Pineapple. All rights reserved.
//

import Foundation

open class CompanyCategory: Equatable {
    public let id: Int
    public let name: String
    public let tags: [String]
    public let companies: [CompanyWithCount]
    
    init(id: Int, name: String, tags: [String], companies: [CompanyWithCount]) {
        self.id = id
        self.name = name
        self.tags = tags
        self.companies = companies
    }
}

public func ==(lhs: CompanyCategory, rhs: CompanyCategory) -> Bool {
    return lhs.id == rhs.id
}
