
//
//  SearchResult.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 11/5/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

class SearchResult {

    let companies: [Company]
    let tags: [String]
    
    init(companies: [Company], tags: [String]) {
        self.companies = companies
        self.tags = tags
    }
    
}