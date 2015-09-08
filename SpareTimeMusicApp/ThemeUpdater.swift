//
//  ThemeUpdater.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/8/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

struct ThemeUpdater {
    static func subscribeAndUpdateBackgroundImage(target: AnyObject, actionClosure: (() -> ())?) {
        ThemeObserver.onMainThread(target, name: ThemeComponent.themeObserverUpdateNotificationKey) { notification in
            if let action = actionClosure {
                actionClosure
            }
        }
    }
    
    static func updateBackgroundImage(imageView: UIImageView) {
        // Set theme
        if let currentTheme = ThemeManager.sharedInstance.stylesheet {
            if let backgroundImageName = currentTheme[ThemeComponent.ThemeAttribute.BackgroundImage] {
                imageView.image = UIImage(named: backgroundImageName)
                // Animate Change
                imageView.layer.animateThemeChangeAnimation()
            }
            
        }
    }
    
    static func subscribeAndUpdateComponentColorWithMandatoryColor(target: AnyObject, inout targetColor: UIColor) {
        ThemeObserver.onMainThread(target, name: ThemeComponent.themeObserverUpdateNotificationKey) { notification in
            // Set theme
            self.updateComponentColorWithMandatoryColor(target, targetColor: &targetColor)
        }
    }
    
    static func updateComponentColorWithMandatoryColor(target: AnyObject, inout targetColor: UIColor) {
        if let currentTheme = ThemeManager.sharedInstance.stylesheet {
            if let mandatoryColorString = currentTheme[ThemeComponent.ThemeAttribute.MandatoryColor] {
                let mandatoryColor = UIColor(rgba: mandatoryColorString)
                targetColor = mandatoryColor
                if let lay = target.layer {
                    // Animate Change
                    lay.animateThemeChangeAnimation()
                }
            }
        }
    }
}
