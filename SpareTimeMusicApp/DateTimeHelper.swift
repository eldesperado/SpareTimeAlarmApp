//
//  DateTimeHelper.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/11/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

struct DateTimeHelper {
    static func getRemainingTimeFromCurrentTime(destinatedTime: NSNumber) -> NSNumber {
        let currentTime = self.getCurrentTime()
        let currentTimeInMinutes: Int = getMinutesForHoursMinutes(currentTime.hours, minutes: currentTime.minutes)
        if currentTimeInMinutes > destinatedTime.integerValue {
            return 1440 - currentTimeInMinutes + destinatedTime.integerValue
        } else {
            return currentTimeInMinutes - destinatedTime.integerValue
        }
    }
    
    static func getCurrentTime() -> (hours: Int, minutes: Int, seconds: Int) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        return (components.hour, components.minute, components.second)
    }
    
    static func getCurrentTimeInMinutes() -> NSNumber {
        let currentTime = self.getCurrentTime()
        return getMinutesForHoursMinutes(currentTime.hours, minutes: currentTime.minutes)
    }
    
    static func getCurrentTimeInSeconds() -> NSNumber {
        let currentTime = self.getCurrentTime()
        return getMinutesForHoursMinutesSeconds(currentTime.hours, minutes: currentTime.minutes, seconds: currentTime.seconds)
    }
    
    static func getMinutesForHoursMinutes(hours: Int, minutes: Int) -> Int {
        return hours * 60 + minutes
    }
    
    static func getMinutesForHoursMinutesSeconds(hours: Int, minutes: Int, seconds: Int) -> Int {
        return hours * 360 + minutes * 60 + seconds
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
    
    static func getAlarmTime(let alarmTime time: NSNumber) -> String {
        let hour = time.integerValue / 60
        let minute = time.integerValue - hour * 60
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
        let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
        return "\(hourString):\(minuteString)"
    }
}
