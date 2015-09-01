//
//  ThemeComponent.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/1/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//


struct ThemeComponent {
    enum ThemeType: String {
        case Default = "defaultTheme"
        case Orange = "orangeTheme"
    }
    
    enum ThemeAttribute: String {
        case BackgroundImage = "BackgroundImage"
        case SecondaryColor = "SecondaryColor"
        case MandatoryColor = "MandatoryColor"
        
        func getString() -> String {
            return self.rawValue
        }
    }
    typealias Theme = [ThemeAttribute: String]
    
    static let themeObserverUpdateNotificationKey: String = "com.xmsofresh.SpareTimeAppAlarm.ThemeManager.UpdateTheme"
}


extension ThemeComponent.ThemeAttribute {
    init?(string: String) {
        switch (string.lowercaseString) {
        case ThemeComponent.ThemeAttribute.BackgroundImage.getString().lowercaseString:
            self = .BackgroundImage
        case ThemeComponent.ThemeAttribute.SecondaryColor.getString().lowercaseString:
            self = .SecondaryColor
        case ThemeComponent.ThemeAttribute.MandatoryColor.getString().lowercaseString:
            self = .MandatoryColor
        default:
            return nil
        }
    }
}

extension ThemeComponent.ThemeType {
    init?(string: String) {
        switch (string.lowercaseString) {
        case ThemeComponent.ThemeType.Default.getString().lowercaseString:
            self = .Default
        case ThemeComponent.ThemeType.Orange.getString().lowercaseString:
            self = .Orange
        default:
            return nil
        }
    }
    
    
    func getString() -> String {
        return self.rawValue
    }
}
