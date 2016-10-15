//
//  SearchHistory.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 13/5/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

enum SearchHistory: Equatable {
    case location(name: String, address: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    case company(id: Int, name: String)
    case tag(tag: String)
    
    func toJson() -> JSON {
        switch self {
        case .company(let id, let name):
            return JSON(["type": "Company", "id": id, "name": name])
        case .location(let name, let address, let latitude, let longitude):
            return JSON(["type": "Location", "name": name, "address": address ?? "", "lat": latitude, "lng": longitude])
        case .tag(let tag):
            return JSON(["type": "Tag", "tag": tag])
        }
    }
    
    static func fromJson(_ json: JSON) -> SearchHistory? {
        switch (json["type"].string) {
        case .some("Company"):
            return .Company(id: json["id"].intValue, name: json["name"].stringValue)
        case .some("Location"):
            return .Location(name: json["name"].stringValue, address: json["address"].string, latitude: json["lat"].doubleValue, longitude: json["lng"].doubleValue)
        case .some("Tag"):
            return .Tag(tag: json["tag"].stringValue)
        default:
            return .none
        }
    }
}


func ==(lhs: SearchHistory, rhs: SearchHistory) -> Bool {
    switch lhs {
    case .company(let lhsId, let lhsName):
        switch rhs {
        case .company(let rhsId, let rhsName):
            return lhsId == rhsId && lhsName == rhsName
        default:
            return false
        }
    case .location(let lhsName, let lhsAddress, _, _):
        switch rhs {
        case .location(let rhsName, let rhsAddress, _, _):
            return lhsName == rhsName && lhsAddress == rhsAddress
        default:
            return false
        }
    case .tag(let lhsTag):
        switch rhs {
        case .tag(let rhsTag):
            return lhsTag == rhsTag
        default:
            return false
        }
    }
}
