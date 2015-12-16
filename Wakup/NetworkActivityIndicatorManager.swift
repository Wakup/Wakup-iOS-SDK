//
//  NetworkActivityIndicatorManager.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 12/5/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

class NetworkActivityIndicatorManager {
    
    class var sharedInstance: NetworkActivityIndicatorManager {
        struct Static {
            static let instance: NetworkActivityIndicatorManager = NetworkActivityIndicatorManager()
        }
        return Static.instance
    }
    
    private let application = UIApplication.sharedApplication()
    private var tasks = 0
    
    func startActivity() {
        if application.statusBarHidden {
            return
        }
        synced(self, closure: {
            if !self.application.networkActivityIndicatorVisible {
                self.application.networkActivityIndicatorVisible = true
                self.tasks = 0
            }
            self.tasks += 1
        })
    }
    
    func endActivity() {
        if application.statusBarHidden {
            return
        }
        synced(self, closure: {
            self.tasks -= 1
            
            if (self.tasks <= 0) {
                self.application.networkActivityIndicatorVisible = false
                self.tasks = 0
            }
        })
    }
    
    func endAllActivities() {
        if application.statusBarHidden {
            return
        }
        synced(self, closure: {
            self.application.networkActivityIndicatorVisible = false
            self.tasks = 0
        })
    }
    
}