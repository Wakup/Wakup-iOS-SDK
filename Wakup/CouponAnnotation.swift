//
//  CouponAnnotation.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 05/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import MapKit

class CouponAnnotation: NSObject, MKAnnotation {
    let coupon: Coupon
    
    var coordinate: CLLocationCoordinate2D { get { return coupon.store?.location()?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0) } }
    
    var title: String? { get { return coupon.company.name } }
    var subtitle: String? { get { return coupon.store?.address } }
    
    
    init(coupon: Coupon) {
        self.coupon = coupon
        super.init()
    }
}