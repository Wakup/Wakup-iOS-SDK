//
//  BaseService.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 15/2/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class BaseService {
    var apiKey: String?
    var authHeaders: [String: String]? { return apiKey.map{ ["API-Token": $0] } }
    
    let offerHostUrl = ProcessInfo.processInfo.environment["OFFERS_SERVER_URL"] ?? "https://app.wakup.net/"
    
    func userHeaders(_ userToken: String) -> [String: String] {
        var headers = authHeaders ?? [:]
        headers["User-Token"] = userToken
        return headers
    }
    
    func createRequest(
        _ method: HTTPMethod,
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        withUserToken: Bool = true,
        completion: @escaping (JSON?, Error?) -> Void)
    {
        let performRequest = { (headers: [String: String]) in
            NetworkActivityIndicatorManager.sharedInstance.startActivity()
            let r = request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseSwiftyJSON { result in
                NetworkActivityIndicatorManager.sharedInstance.endActivity()
                switch result.result {
                case .failure(let error):
                    print("Error in request with URL", result.request!.url!, error)
                    completion(nil, error)
                case .success(let json):
                    print("Success", result.request!.url!, result.data.flatMap { String(data: $0, encoding: .utf8) } ?? "")
                    completion(json, nil)
                }
            }
            print("Creating request with URL", r.request!.url!)
        }
        
        if withUserToken {
            UserService.sharedInstance.fetchUserToken { (userToken, error) in
                guard let userToken = userToken else {
                    completion(nil, error!)
                    return
                }
                
                performRequest(self.userHeaders(userToken))
            }
        }
        else {
            performRequest(authHeaders ?? [:])
        }
    }
}
