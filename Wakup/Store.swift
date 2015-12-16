//
//  Store.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation

class Store {
    let id: Int
    let name: String?
    let address: String?
    let latitude, longitude: Float?
    
    init(id: Int, name: String?, address: String?, latitude: Float?, longitude: Float?) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}