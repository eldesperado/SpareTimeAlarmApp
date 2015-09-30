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
        ThemeObserver.onMainThread(self) { [weak self] notification in
            self?.updateDependOnTheme()
        }
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        updateDependOnTheme()
    }
    
    private func updateDependOnTheme() {
        // Set theme
        if let themeColor = ThemeManager.getSharedInstance().getThemeComponent(ThemeComponent.ThemeAttribute.MandatoryColor) as? UIColor {
            trackTintColor  = themeColor
            // Animate Change
            layer.animateThemeChangeAnimation()
        }
    }
}

extension NTSwitch {
    func subscribleToUpdateDependOnCurrentTheme() {
        ThemeObserver.onMainThread(self) { [weak self] notification in
            self?.updateDependOnTheme()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        updateDependOnTheme()
    }
    
    private func updateDependOnTheme() {
        // Set theme
        if let themeColor = ThemeManager.getSharedInstance().getThemeComponent(ThemeComponent.ThemeAttribute.MandatoryColor) as? UIColor {
            onTintColor  = themeColor
            // Animate Change
            layer.animateThemeChangeAnimation()
        }
    }
}
