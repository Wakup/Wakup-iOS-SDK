//
//  BaseService.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 15/2/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

public class BaseService {
    var apiKey: String?
    var authHeaders: [String: String]? { return apiKey.map{ ["API-Token": $0] } }
    
    let offerHostUrl = ProcessInfo.processInfo.environment["OFFERS_SERVER_URL"] ?? "https://app.wakup.net/"
    
    func userHeaders(_ userToken: String) -> [String: String] {
        var headers = authHeaders ?? [String: String]()
        headers["User-Token"] = userToken
        return headers
    }
}
