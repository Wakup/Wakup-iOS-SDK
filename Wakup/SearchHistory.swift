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
    case Location(name: String, address: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    case Company(id: Int, name: String)
    case Tag(tag: String)
    
    func toJson() -> JSON {
        switch self {
        case .Company(let id, let name):
            return JSON(["type": "Company", "id": id, "name": name])
        case .Location(let name, let address, let latitude, let longitude):
            return JSON(["type": "Location", "name": name, "address": address ?? "", "lat": latitude, "lng": longitude])
        case .Tag(let tag):
            return JSON(["type": "Tag", "tag": tag])
        }
    }
    
    static func fromJson(json: JSON) -> SearchHistory? {
        switch (json["type"].string) {
        case .Some("Company"):
            return .Company(id: json["id"].intValue, name: json["name"].stringValue)
        case .Some("Location"):
            return .Location(name: json["name"].stringValue, address: json["address"].string, latitude: json["lat"].doubleValue, longitude: json["lng"].doubleValue)
        case .Some("Tag"):
            return .Tag(tag: json["tag"].stringValue)
        default:
            return .None
        }
    }
}


func ==(lhs: SearchHistory, rhs: SearchHistory) -> Bool {
    switch lhs {
    case .Company(let lhsId, let lhsName):
        switch rhs {
        case .Company(let rhsId, let rhsName):
            return lhsId == rhsId && lhsName == rhsName
        default:
            return false
        }
    case .Location(let lhsName, let lhsAddress, _, _):
        switch rhs {
        case .Location(let rhsName, let rhsAddress, _, _):
            return lhsName == rhsName && lhsAddress == rhsAddress
        default:
            return false
        }
    case .Tag(let lhsTag):
        switch rhs {
        case .Tag(let rhsTag):
            return lhsTag == rhsTag
        default:
            return false
        }
    }
}