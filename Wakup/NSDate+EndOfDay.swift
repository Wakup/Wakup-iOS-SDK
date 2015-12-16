//
//  NSDate+EndOfDay.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 03/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

extension NSDate {
    func beginningOfDay() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit], fromDate: self)
        return calendar.dateFromComponents(components)!
    }
    
    func endOfDay() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.day = 1
        
        let date = calendar.dateByAddingComponents(components, toDate: self.beginningOfDay(), options: NSCalendarOptions(rawValue: 0))
        return date!.dateByAddingTimeInterval(-1)
    }
}