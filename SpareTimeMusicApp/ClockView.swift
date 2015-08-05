//
//  ClockView.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/4/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class ClockView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond | .CalendarUnitWeekday | .CalendarUnitDay, fromDate: date)
        let hour: CGFloat = CGFloat(components.hour)
        let minute: CGFloat = CGFloat(components.minute)
        let second: CGFloat = CGFloat(components.second)
        let dateInWeek: String = components.day.description
        let dateInMonth: String = components.weekday.description
        ClockStyleKit.drawClock(seconds: second, minutes: minute, hours: hour, dateInWeek: dateInWeek, dateInMonth: dateInMonth)
    }
    
}
