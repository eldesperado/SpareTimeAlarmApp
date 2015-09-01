//
//  NTTableView.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/27/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class NTTableView: UITableView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupThemeManagerNotification()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupThemeManagerNotification()
    }
    
    private func setupThemeManagerNotification() {
        
        ThemeObserver.onMainThread(self, name: ThemeComponent.themeObserverUpdateNotificationKey) { notification in
            // Set theme
            if let currentTheme = ThemeManager.sharedInstance.stylesheet {
                if let backgroundImageName = currentTheme[ThemeComponent.ThemeAttribute.BackgroundImage] {
                    let view = self.backgroundView as! UIImageView
                    view.image = UIImage(named: backgroundImageName)
                    let animation: CATransition = CATransition()
                    animation.duration = 0.6
                    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    animation.type = kCATransitionFade
                    
                    view.layer.addAnimation(animation, forKey: nil)
                }
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // Set theme
        if let currentTheme = ThemeManager.sharedInstance.stylesheet {
            if let backgroundImageName = currentTheme[ThemeComponent.ThemeAttribute.BackgroundImage] {
                self.backgroundView = UIImageView(image: UIImage(named: backgroundImageName))
            }
        }
        // Hide footer
        self.tableFooterView = UIView(frame: CGRectZero)
    }
    
    deinit {
        ThemeObserver.unregister(self)
    }
}
