//
//  DateTimeHelper.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/11/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit
import Timepiece
import Foundation

protocol NumberToDateProtocol {
    var simpleDescription: String { get }
}

enum NumberToDate: Int, NumberToDateProtocol, RawRepresentable {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    var simpleDescription: String {
        get {
            return self.getDescription()
        }
    }
    
    var date: Int {
        get {
            return self.rawValue
        }
    }
    
    init?(dateNumber: Int) {
        self.init(rawValue: dateNumber)
    }
    
    private func getDescription() -> String {
        switch self {
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        case .Sunday:
            return "Sunday"
        }
    }
    
    func getIsRepeat(repeatDate: RepeatDate) -> Bool {
        switch self {
        case .Monday:
            return repeatDate.isMon.boolValue
        case .Tuesday:
            return repeatDate.isTue.boolValue
        case .Wednesday:
            return repeatDate.isWed.boolValue
        case .Thursday:
            return repeatDate.isThu.boolValue
        case .Friday:
            return repeatDate.isFri.boolValue
        case .Saturday:
            return repeatDate.isSat.boolValue
        case .Sunday:
            return repeatDate.isSun.boolValue
        }
    }
}

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
    
    static func getAlarmTimeComponents(let alarmTime time: NSNumber) -> (hour: Int, minutes: Int) {
        let hour = time.integerValue / 60
        let minute = time.integerValue - hour * 60
        return (hour, minute)
    }
    
    static func resetSecondToZero(date: NSDate) {
        date.change(second: 0)
    }
}
