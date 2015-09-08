//
//  NTTableView.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/27/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class NTTableView: UITableView {
    // MARK: Initilization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupThemeManagerNotification()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupThemeManagerNotification()
    }
    
    private func setupThemeManagerNotification() {
        if let themeImage = ThemeManager.sharedInstance.getThemeComponent(ThemeComponent.ThemeAttribute.MandatoryColor) as? UIImage ,
            view = self.backgroundView as? UIImageView {
                view.image = themeImage
                // Animate Change
                view.layer.animateThemeChangeAnimation()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // Set theme
        if let currentTheme = ThemeManager.sharedInstance.stylesheet, backgroundImageName = currentTheme[ThemeComponent.ThemeAttribute.BackgroundImage] {
            self.backgroundView = UIImageView(image: UIImage(named: backgroundImageName))
        }
        // Hide footer
        self.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: Deinit
    deinit {
        ThemeObserver.unregister(self)
    }
}
