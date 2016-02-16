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
    
    var deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    func fetchUserToken(completion: (String?, ErrorType?) -> Void) {
        if let userToken = userToken {
            completion(userToken, nil)
        }
        else {
            register(completion)
        }
    }
    
    func register(completion: (String?, ErrorType?) -> Void) {
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
    
    
    private func deviceParameters() -> [String: AnyObject] {
        var param = [String: AnyObject?]()
        
        param["deviceId"] = deviceId
        param["appId"] = NSBundle.mainBundle().bundleIdentifier
        param["appVersion"] = appVersion
        param["sdkVersion"] = sdkVersion
        param["osName"] = UIDevice.currentDevice().systemName
        param["osVersion"] = UIDevice.currentDevice().systemVersion
        param["platform"] = "ios"
        param["deviceManufacturer"] = "Apple"
        param["deviceModel"] = UIDevice.currentDevice().model
        param["deviceCode"] = Diagnostics.platform
        param["locale"] = NSLocale.currentLocale().localeIdentifier
        
        return param.flatten()
    }

    private var appVersion: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    private var sdkVersion: String? {
        return NSBundle(forClass: self.dynamicType).infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    private var modelCode: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        return NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: NSASCIIStringEncoding) as! String
    }
}