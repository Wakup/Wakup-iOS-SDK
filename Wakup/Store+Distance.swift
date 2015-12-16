//
//  Store+Distance.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 03/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import CoreLocation

extension Store {
    func distance(toLocation: CLLocation) -> CLLocationDistance? {
        return getDistance(toLocation) <^> location()
    }
    
    func location() -> CLLocation? {
        return getLocation <^> latitude <*> longitude
    }
    
    private func getLocation(latitude: Float)(longitude: Float) -> CLLocation {
        return CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    private func getDistance(loc1: CLLocation)(loc2: CLLocation) -> CLLocationDistance {
        return loc1.distanceFromLocation(loc2)
    }
}