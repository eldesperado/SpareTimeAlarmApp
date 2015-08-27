//
//  ThemeManager.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/27/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {
    // MARK: Attributes
    
    // Public Attributes
    var stylesheet: Theme?
    
    // Private Attributes
    internal enum ThemeAttribute: String {
        case BackgroundImage = "BackgroundImage"
        case SecondaryColor = "SecondaryColor"
        case MandatoryColor = "MandatoryColor"
        
        func getValue() -> String {
            return self.rawValue
        }
    }
    typealias Theme = [ThemeAttribute: String]
    
    
    // Constants
    private let storedKeyInUserDefaults: String = "com.xmsofresh.SpareTimeAppAlarm.ThemeManager"
    private let defaultThemeName: String = "defaultTheme"
    private let orangeThemeName: String = "orangeTheme"
    
    // MARK: Singleton
    static let sharedInstance = ThemeManager()
    
    override init() {
        super.init()
        // Setup Theme
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let themeName: String = (userDefault.objectForKey(self.storedKeyInUserDefaults) ?? defaultThemeName) as! String
        if let stylesheetPath = NSBundle.mainBundle().pathForResource(themeName, ofType: "plist") {
            if let stylesheetData = NSDictionary(contentsOfFile: stylesheetPath) {
                self.stylesheet = loadTheme(stylesheetData)
            }
        }
        
    }
    
    // Load Theme
    private func loadTheme(stylesheetDictionary: NSDictionary) -> Theme {
        var theme: Theme = [ThemeAttribute.BackgroundImage : "",
        ThemeAttribute.SecondaryColor : "",
        ThemeAttribute.MandatoryColor : ""]
        var dictKey: ThemeAttribute
        for (key, value) in stylesheetDictionary {
            if let k = getThemeAttribute(key as! String) {
                theme.updateValue(value as! String, forKey: k)
            }
        }
        return theme
    }
    
    // Helpers
    private func getThemeAttribute(key: String) -> ThemeAttribute? {
        switch (key) {
        case ThemeAttribute.BackgroundImage.getValue():
            return ThemeAttribute.BackgroundImage
        case ThemeAttribute.SecondaryColor.getValue():
            return ThemeAttribute.SecondaryColor
        case ThemeAttribute.MandatoryColor.getValue():
            return ThemeAttribute.MandatoryColor
        default:
            return nil
        }
    }
}
