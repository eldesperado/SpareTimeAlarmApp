//
//  DateTimeHelper.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/11/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

struct DateTimeHelper {
    static func getCurrentTime() -> (hours: Int, minutes: Int, seconds: Int) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        return (components.hour, components.minute, components.second)
    }
    
    static func getMinutesForHoursMinutes(hours: Int, minutes: Int) -> Int {
        return hours * 60 + minutes
    }
    
    static func getCurrentDate() -> (month: Int, day: Int, dayOfWeek: Int, dayOfWeekAsString: String) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday, fromDate: date)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekdayString = dateFormatter.stringFromDate(date)
        return (components.hour, components.day, components.weekday, weekdayString)
    }
}
