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
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    observeTheme()
  }
  
  private func observeTheme() {
    ThemeObserver.onMainThread(self) { [weak self] notification in
      // Set theme
      if let themeColor = ThemeManager.getSharedInstance().getThemeComponent(ThemeComponent.ThemeAttribute.MandatoryColor) as? UIColor {
        self?.lightHandColor  = themeColor
      }
    }
    
  }
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    let currentTime = DateTimeHelper.getCurrentTime()
    
    if let lightHColor = lightHandColor {
      FlatClockStyleKit.drawClock(frame: rect, lightHandColor: lightHColor, hours: CGFloat(currentTime.hours), minutes: CGFloat(currentTime.minutes), seconds: CGFloat(currentTime.seconds))
    } else {
      FlatClockStyleKit.drawClock(frame: rect, hours: CGFloat(currentTime.hours), minutes: CGFloat(currentTime.minutes), seconds: CGFloat(currentTime.seconds))
    }
  }
  
}
