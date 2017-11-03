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
    public func distance(_ toLocation: CLLocation) -> CLLocationDistance? {
        return location().map { self.getDistance($0, toLocation) }
    }
    
    public func location() -> CLLocation? {
        if let latitude = latitude, let longitude = longitude {
            return getLocation(latitude, longitude)
        }
        return nil

    }
    
    fileprivate func getLocation(_ latitude: Float, _ longitude: Float) -> CLLocation {
        return CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    fileprivate func getDistance(_ loc1: CLLocation, _ loc2: CLLocation) -> CLLocationDistance {
        return loc1.distance(from: loc2)
    }
}
