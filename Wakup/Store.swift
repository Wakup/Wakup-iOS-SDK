//
//  Store.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation

public class Store {
    public let id: Int
    public let name: String?
    public let address: String?
    public let latitude, longitude: Float?
    
    public init(id: Int, name: String?, address: String?, latitude: Float?, longitude: Float?) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}