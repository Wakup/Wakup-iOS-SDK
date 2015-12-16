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
        switch (self.timeIntervalSinceNow, dateComponents()) {
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
        let now = NSDate()
        let components = calendar.components([NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit], fromDate: now, toDate: self, options: NSCalendarOptions(rawValue: 0))
        
        return (components.year, components.month, components.day)
    }
}