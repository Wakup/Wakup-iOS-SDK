//
//  RedemptionCodeInfo.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 22/6/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

open class RedemptionCodeInfo {
    open let limited: Bool
    open let totalCodes: Int?
    open let availableCodes: Int?
    open let alreadyAssigned: Bool
    
    public init(limited: Bool, totalCodes: Int?, availableCodes: Int?, alreadyAssigned: Bool) {
        self.limited = limited
        self.totalCodes = totalCodes
        self.availableCodes = availableCodes
        self.alreadyAssigned = alreadyAssigned
    }
}
