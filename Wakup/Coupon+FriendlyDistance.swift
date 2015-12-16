//
//  Coupon+FriendlyDistance.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 03/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import CoreLocation

extension Coupon {
    func distanceText(toLocation: CLLocation) -> String {
        switch (store?.distance(toLocation) ?? .None, online) {
        case (.Some(let d), _) where d < 1_000: return String(format: "%.0f m", d)
        case (.Some(let d), _) where d < 10_000: return String(format: "%.2f km", d / 1000)
        case (.Some(let d), _) where d < 100_000: return String(format: "%.1f km", d / 1000)
        case (.Some(let d), _): return String(format: "%.0f km", d / 1000)
        case (_, true): return "OnlineCoupon".i18n()
        default: return "-"
        }
    }
}