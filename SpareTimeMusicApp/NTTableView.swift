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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observeTheme()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        observeTheme()
    }
    
    private func observeTheme() {
        ThemeObserver.onMainThread(self) { [weak self] notification in
            // Set theme
            if let themeImage = ThemeManager.getSharedInstance().getThemeComponent(ThemeComponent.ThemeAttribute.BackgroundImage) as? UIImage ,
                view = self?.backgroundView as? UIImageView {
                    view.image = themeImage
                    // Animate Change
                    view.layer.animateThemeChangeAnimation()
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // Set theme
        if let themeImage = ThemeManager.getSharedInstance().getThemeComponent(ThemeComponent.ThemeAttribute.BackgroundImage) as? UIImage {
            backgroundView = UIImageView(image: themeImage)
        }
        // Hide footer
        tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: Deinit
    deinit {
        ThemeObserver.unregister(self)
    }
}
