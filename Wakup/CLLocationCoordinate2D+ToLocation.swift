//
//  CLLocationCoordinate2D+ToLocation.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func toLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func isEqualTo(_ other: CLLocationCoordinate2D) -> Bool {
        return latitude == other.latitude && longitude == other.longitude
    }
}
