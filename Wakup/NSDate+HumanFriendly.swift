//
//  NSDate+HumanFriendly.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 03/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

extension NSDate {
    func humanFriendlyDate() -> String {
        switch (self.timeIntervalSinceDate(NSDate().atBeginningOfDay()), dateComponents()) {
        case (let i, _) where i < 0: return "Expired".i18n()
        case (_, (0, 0, 0)): return "ExpiresToday".i18n()
        case (_, (0, 0, 1)): return "ExpiresTomorrow".i18n()
        case (_, (0, 0, let days)): return String(format: "ExpiresInXDays".i18n(), days)
        case (_, (0, 1, _)): return "ExpiresIn1Month".i18n()
        case (_, (0, let months, _)): return String(format: "ExpiresInXMonths".i18n(), months)
        default:
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.stringFromDate(self)
        }
    }
    
    func dateComponents() -> (Int, Int, Int) {
        let calendar = NSCalendar.currentCalendar()
        let today = NSDate().atBeginningOfDay()
        let components = calendar.components([.Year, .Month, .Day], fromDate: today, toDate: self, options: [])
        
        return (components.year, components.month, components.day)
    }
    
    func atBeginningOfDay() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: self)
        return calendar.dateFromComponents(components)!
    }
}