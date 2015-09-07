//
//  ClockView.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/4/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class ClockView: UIView {
    
    var lightHandColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        observeTheme()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observeTheme()
    }
    
    private func observeTheme() {
        ThemeObserver.onMainThread(self, name: ThemeComponent.themeObserverUpdateNotificationKey) { [unowned self] notification in
            // Set theme
            if let currentTheme = ThemeManager.sharedInstance.stylesheet {
                if let mandatoryColorString = currentTheme[ThemeComponent.ThemeAttribute.MandatoryColor] {
                    self.lightHandColor = UIColor(rgba: mandatoryColorString)
                }
            }
        }

    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let currentDate = DateTimeHelper.getCurrentDate()
        let currentTime = DateTimeHelper.getCurrentTime()
        
        if let lightHColor = self.lightHandColor {
            FlatClockStyleKit.drawClock(frame: rect, lightHandColor: lightHColor, hours: CGFloat(currentTime.hours), minutes: CGFloat(currentTime.minutes), seconds: CGFloat(currentTime.seconds))
        } else {
            FlatClockStyleKit.drawClock(frame: rect, hours: CGFloat(currentTime.hours), minutes: CGFloat(currentTime.minutes), seconds: CGFloat(currentTime.seconds))
        }
    }
    
}
