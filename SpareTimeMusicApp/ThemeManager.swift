//
//  ThemeManager.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/27/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {
  // Public Attributes
  var stylesheet: ThemeComponent.Theme?
  var currentThemeType: ThemeComponent.ThemeType?
  
  
  // Constants
  private let storedKeyInUserDefaults = "com.xmsofresh.SpareTimeAppAlarm.ThemeManager"
  
  // MARK: Singleton
  private static let sharedInstance = ThemeManager()
  
  
  // MARK: Public Methods
  func saveTheme(theme: ThemeComponent.ThemeType) {
    if let newTheme = loadTheme(theme) {
      // Update Stylesheet
      stylesheet = newTheme
      // Update current theme
      currentThemeType = theme
      // Save to NSUserDefaults
      NSUserDefaults.standardUserDefaults().setValue(theme.getString(), forKey: storedKeyInUserDefaults)
      NSUserDefaults.standardUserDefaults().synchronize()
      // Post notification
      postThemeUpdateNotification()
    }
  }
  
  static func getSharedInstance() -> ThemeManager {
    return sharedInstance
  }
  
  func getThemeComponent(component: ThemeComponent.ThemeAttribute) -> AnyObject? {
    if let currentTheme = ThemeManager.sharedInstance.stylesheet,
      attributeValue = currentTheme[component] {
        switch (component) {
        case .BackgroundColor:
          return UIColor(rgba: attributeValue)
        case .BackgroundImage:
          return UIImage(named: attributeValue)
        case .MandatoryColor:
          return UIColor(rgba: attributeValue)
        }
    } else {
      return nil
    }
  }
  
  // MARK: Initialization
  override init() {
    super.init()
    // Setup Theme
    setup()
  }
  
  // MARK: Setup
  private func setup() {
    // Get Current Theme stored in userDefaults
    let themeName: String = (NSUserDefaults.standardUserDefaults().objectForKey(storedKeyInUserDefaults) ?? ThemeComponent.ThemeType.Default.getString()) as! String
    // Get the current theme type
    if let currTheme = ThemeComponent.ThemeType(string: themeName) {
      currentThemeType = currTheme
    }
    // Load stored stylesheet
    if let theme = getStylesheetFromFile(themeName) {
      stylesheet = theme
    }
  }
  
  
  // Load Theme
  private func loadTheme(theme: ThemeComponent.ThemeType) -> ThemeComponent.Theme? {
    if let resultTheme: ThemeComponent.Theme = getStylesheetFromFile(theme.getString()) {
      return resultTheme
    } else {
      return nil
    }
  }
  
  private func loadTheme(stylesheetDictionary: NSDictionary) -> ThemeComponent.Theme {
    var theme: ThemeComponent.Theme = [ThemeComponent.ThemeAttribute.BackgroundImage : "",
      ThemeComponent.ThemeAttribute.BackgroundColor : "",
      ThemeComponent.ThemeAttribute.MandatoryColor : ""]
    
    for (key, value) in stylesheetDictionary {
      if let k = ThemeComponent.ThemeAttribute(string: key as! String) {
        theme.updateValue(value as! String, forKey: k)
      }
    }
    return theme
  }
  
  private func postThemeUpdateNotification() {
    ThemeObserver.post(sender: self)
  }
  
  // Helpers
  private func getStylesheetFromFile(fileName: String) -> ThemeComponent.Theme? {
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
