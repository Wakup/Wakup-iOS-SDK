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
    let displayCode: String
    let formats: [String]
    
    init(code: String, displayCode: String, formats: [String]) {
        self.code = code
        self.displayCode = displayCode
        self.formats = formats
    }
}