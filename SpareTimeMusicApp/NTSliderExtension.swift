//
//  NTSliderExtension.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/1/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

extension NTSlider {
    func subscribleToUpdateDependOnCurrentTheme() {
        ThemeObserver.onMainThread(self, name: ThemeComponent.themeObserverUpdateNotificationKey) { notification in
            self.updateDependOnTheme()
        }
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.updateDependOnTheme()
    }
    
    private func updateDependOnTheme() {
        // Set theme
        if let currentTheme = ThemeManager.sharedInstance.stylesheet {
            if let mandatoryColorString = currentTheme[ThemeComponent.ThemeAttribute.MandatoryColor] {
                let mandatoryColor = UIColor(rgba: mandatoryColorString)
                self.trackTintColor = mandatoryColor
                // Animate Change
                self.layer.animateThemeChangeAnimation()
            }
        }
    }
}

extension NTSwitch {
    func subscribleToUpdateDependOnCurrentTheme() {
        ThemeObserver.onMainThread(self, name: ThemeComponent.themeObserverUpdateNotificationKey) { notification in
            self.updateDependOnTheme()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.updateDependOnTheme()
    }
    
    private func updateDependOnTheme() {
        // Set theme
        if let currentTheme = ThemeManager.sharedInstance.stylesheet {
            if let mandatoryColorString = currentTheme[ThemeComponent.ThemeAttribute.MandatoryColor] {
                let mandatoryColor = UIColor(rgba: mandatoryColorString)
                self.onTintColor = mandatoryColor
                // Animate Change
                self.layer.animateThemeChangeAnimation()
            }
        }
    }
}
