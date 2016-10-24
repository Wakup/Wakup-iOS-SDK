//
//  UserService.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 16/2/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation
import Alamofire

class UserService: BaseService {
    static let sharedInstance = UserService()
    
    var userToken: String?
    
    var deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    func fetchUserToken(_ completion: @escaping (String?, Error?) -> Void) {
        if let userToken = userToken {
            completion(userToken, nil)
        }
        else {
            register(completion)
        }
    }
    
    func register(_ completion: @escaping (String?, Error?) -> Void) {
        let url = "\(offerHostUrl)register"
        let parameters = deviceParameters()
        
        NetworkActivityIndicatorManager.sharedInstance.startActivity()
        let r = request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: authHeaders).validate().responseSwiftyJSON { result in
            NetworkActivityIndicatorManager.sharedInstance.endActivity()
            switch result.result {
            case .failure(let error):
                print("Error in request with URL \(result.request?.url): \(error)")
                completion(nil, error)
            case .success(let json):
                NSLog("Success \(result.request?.url): \(result.data.map { String(data: $0, encoding: .utf8) })")
                let userToken = json["userToken"].stringValue
                self.userToken = userToken
                completion(userToken, nil)
            }
        }
        NSLog("Registering with URL: \(r.request?.url)")
    }
    
    
    fileprivate func deviceParameters() -> [String: Any] {
        var param = [String: Any?]()
        
        param["deviceId"] = deviceId
        param["appId"] = Bundle.main.bundleIdentifier
        param["appVersion"] = appVersion
        param["sdkVersion"] = sdkVersion
        param["osName"] = UIDevice.current.systemName
        param["osVersion"] = UIDevice.current.systemVersion
        param["platform"] = "ios"
        param["deviceManufacturer"] = "Apple"
        param["deviceModel"] = UIDevice.current.model
        param["deviceCode"] = modelCode
        param["locale"] = Locale.current.identifier
        
        return param.flatten()
    }

    fileprivate var appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    fileprivate var sdkVersion: String? {
        return Bundle(for: type(of: self)).infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    fileprivate var modelCode: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
