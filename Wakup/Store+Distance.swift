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
    func distance(_ toLocation: CLLocation) -> CLLocationDistance? {
        return getDistance(toLocation) <^> location()
    }
    
    func location() -> CLLocation? {
        return getLocation <^> latitude <*> longitude
    }
    
    fileprivate func getLocation(_ latitude: Float, _ longitude: Float) -> CLLocation {
        return CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    fileprivate func getDistance(_ loc1: CLLocation, _ loc2: CLLocation) -> CLLocationDistance {
        return loc1.distance(from: loc2)
    }
}
