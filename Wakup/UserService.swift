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
        let r = request(.POST, url, parameters: parameters, encoding: .JSON, headers: authHeaders).validate().responseSwiftyJSON({ (req, res, result, error) -> Void in
            NetworkActivityIndicatorManager.sharedInstance.endActivity()
            if let error = error {
                print("Error in request with URL \(req.URLString): \(error)")
                completion(nil, error)
            }
            else  {
                NSLog("Success %@: %@)", req.URLString, result.rawString()!)
                let userToken = result["userToken"].stringValue
                self.userToken = userToken
                completion(userToken, nil)
            }
        })
        NSLog("Registering with URL: %@", r.request!.URLString)
    }
    
    
    fileprivate func deviceParameters() -> [String: AnyObject] {
        var param = [String: AnyObject?]()
        
        param["deviceId"] = deviceId as AnyObject??
        param["appId"] = Bundle.main.bundleIdentifier as AnyObject??
        param["appVersion"] = appVersion as AnyObject??
        param["sdkVersion"] = sdkVersion as AnyObject??
        param["osName"] = UIDevice.current.systemName as AnyObject??
        param["osVersion"] = UIDevice.current.systemVersion as AnyObject??
        param["platform"] = "ios" as AnyObject??
        param["deviceManufacturer"] = "Apple" as AnyObject??
        param["deviceModel"] = UIDevice.current.model as AnyObject??
        param["deviceCode"] = Diagnostics.platform as AnyObject??
        param["locale"] = Locale.current.identifier as AnyObject??
        
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
        
        return NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue) as! String
    }
}
