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
        let currentDate = DateTimeHelper.getCurrentDate()
        let currentTime = DateTimeHelper.getCurrentTime()
        ClockStyleKit.drawClock(seconds: CGFloat(currentTime.seconds), minutes: CGFloat(currentTime.minutes), hours: CGFloat(currentTime.hours), dateInWeek: currentDate.dayOfWeekAsString, dateInMonth: currentDate.day.description)
    }
    
}
