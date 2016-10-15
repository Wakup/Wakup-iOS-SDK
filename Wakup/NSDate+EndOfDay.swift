//
//  NSDate+EndOfDay.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 03/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

extension Date {
    func beginningOfDay() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([NSCalendar.Unit.NSYearCalendarUnit, NSCalendar.Unit.NSMonthCalendarUnit, NSCalendar.Unit.NSDayCalendarUnit], from: self)
        return calendar.date(from: components)!
    }
    
    func endOfDay() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 1
        
        let date = (calendar as NSCalendar).date(byAdding: components, to: self.beginningOfDay(), options: NSCalendar.Options(rawValue: 0))
        return date!.addingTimeInterval(-1)
    }
}
