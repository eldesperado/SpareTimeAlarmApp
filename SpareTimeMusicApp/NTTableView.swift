//
//  NTTableView.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/27/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class NTTableView: UITableView {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // Set theme
        if let currentTheme = ThemeManager.sharedInstance.stylesheet {
            if let backgroundImageName = currentTheme[ThemeManager.ThemeAttribute.BackgroundImage] {
                self.backgroundView = UIImageView(image: UIImage(named: backgroundImageName))
            }
        }
        // Hide footer
        self.tableFooterView = UIView(frame: CGRectZero)
    }

}
