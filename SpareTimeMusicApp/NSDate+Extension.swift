//
//  NSDate+Extension.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/25/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

extension NSDate {
    
    func getCurrentCalendarComponents() -> NSDateComponents {
        return NSCalendar.currentCalendar().components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: self)
    }
    
    func change(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> NSDate! {
        let components = self.getCurrentCalendarComponents()
        components.year = year ?? components.year
        components.month = month ?? components.month
        components.day = day ?? components.day
        components.hour = hour ?? components.hour
        components.minute = minute ?? components.minute
        components.second = second ?? components.second
        return NSCalendar.currentCalendar().dateFromComponents(components)
    }
    
    func change(weekday weekday: Int) -> NSDate! {
        return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: weekday, toDate: NSDate(), options: NSCalendarOptions.SearchBackwards)
    }
}
