//
//  RedemptionCodeInfo.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 22/6/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

class RedemptionCodeInfo {
    let limited: Bool
    let totalCodes: Int?
    let availableCodes: Int?
    
    init(limited: Bool, totalCodes: Int?, availableCodes: Int?) {
        self.limited = limited
        self.totalCodes = totalCodes
        self.availableCodes = availableCodes
    }
}