//
//  ClosedRange+Clamp.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 21/12/18.
//  Copyright © 2018 Yellow Pineapple. All rights reserved.
//

import Foundation

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}
