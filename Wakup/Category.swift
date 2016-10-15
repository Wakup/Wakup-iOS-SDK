//
//  Category.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 12/5/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

open class OfferCategory {
    let title: String
    let icon: String
    let associatedTags: [String]
    
    public init(title: String, icon: String, associatedTags: [String]) {
        self.title = title
        self.icon = icon
        self.associatedTags = associatedTags
    }
}
