//
//  RedemptionCode.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 22/6/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

class RedemptionCode {
    let code: String
    let formats: [String]
    
    init(code: String, formats: [String]) {
        self.code = code
        self.formats = formats
    }
}