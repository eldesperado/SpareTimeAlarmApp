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
    
    enum ThemeType: String {
        case Default = "defaultTheme"
        case Orange = "orangeTheme"
        
        func getString() -> String {
            return self.rawValue
        }
    }
    
    // Constants
    private let storedKeyInUserDefaults: String = "com.xmsofresh.SpareTimeAppAlarm.ThemeManager"
    
    // MARK: Singleton
    static let sharedInstance = ThemeManager()
    
    
    // MARK: Public Methods
    func saveTheme(theme: ThemeType) {
        NSUserDefaults.standardUserDefaults().setValue(theme.getString(), forKey: self.storedKeyInUserDefaults)
    }

    // Initialization
    override init() {
        super.init()
        // Setup Theme
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let themeName: String = (userDefault.objectForKey(self.storedKeyInUserDefaults) ?? ThemeType.Default.getString()) as! String
        // Load stored stylesheet
        if let theme = getStylesheetFromFile(themeName) {
            self.stylesheet = theme
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
    
    private func getStylesheetFromFile(fileName: String) -> Theme? {
        if let stylesheetPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist") {
            if let stylesheetData = NSDictionary(contentsOfFile: stylesheetPath) {
                let stylesheet = loadTheme(stylesheetData)
                return stylesheet
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
