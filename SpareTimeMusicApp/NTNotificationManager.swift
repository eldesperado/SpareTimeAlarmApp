//
//  NTNotificationManager.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit
import Foundation
import Timepiece

private protocol NTNotificationManagerProtocol {
    static func setupNotification()
}

struct NTNotificationManager: NTNotificationManagerProtocol {
    
    static func setupNotification() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if (notificationSettings.types == UIUserNotificationType.None) {
            // Specify the notification types.
            var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
            
            
            // Specify the notification actions.
            var dismissAction = UIMutableUserNotificationAction()
            dismissAction.identifier = "Dismiss"
            dismissAction.title = "Dismiss"
            dismissAction.activationMode = UIUserNotificationActivationMode.Background
            dismissAction.destructive = false
            dismissAction.authenticationRequired = false
            
            var snoozeAction = UIMutableUserNotificationAction()
            snoozeAction.identifier = "Snooze"
            snoozeAction.title = "Snooze"
            snoozeAction.activationMode = UIUserNotificationActivationMode.Foreground
            snoozeAction.destructive = false
            snoozeAction.authenticationRequired = false
            
            let actionsArray = NSArray(objects: dismissAction, snoozeAction)
            
            // Specify the category related to the above actions.
            var reminderCategory = UIMutableUserNotificationCategory()
            reminderCategory.identifier = "reminderCategory"
            reminderCategory.setActions(actionsArray as [AnyObject], forContext: UIUserNotificationActionContext.Default)
            reminderCategory.setActions(actionsArray as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
            
            
            let categoriesForSettings = NSSet(objects: reminderCategory)
            
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as Set<NSObject>)
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        }
    }
    
    static func scheduleNewNotification(record: AlarmRecord) {
        // Convert RepeatDates NSManagedObject to an array containing all activated dates
        if let repeatDates: [Int] = RecordHelper.getRepeatDates(record) {
            // For each date in this AlarmRecord's RepeatDate array, create a seperated notification
            for repeatDate in repeatDates {
                if let dateNumber = NumberToDate(dateNumber: repeatDate) {
                    // Get Date
                    let date: NSDate = NSDate().change(weekday: dateNumber.date)
                    // Reset this time's second to 0
                    DateTimeHelper.resetSecondToZero(date)
                    
                    var localNotification = UILocalNotification()
                    localNotification.alertBody = record.salutationText
                    localNotification.alertAction = "View List"
                    localNotification.fireDate = date
                    
                    if record.isRepeat.boolValue {
                        localNotification.repeatInterval = NSCalendarUnit.CalendarUnitWeekday
                    }
                    
                    localNotification.category = "shoppingListReminderCategory"
                    
                    // Set UID for this notification
                    self.setUIDForNotification(localNotification, uid: record.objectID.description)
                    
                    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                }
                
            }
        }
    }
    
    static func findExistedLocalNotification(uid: String) -> UILocalNotification? {
        let app: UIApplication = UIApplication.sharedApplication()
        for oneEvent in app.scheduledLocalNotifications {
            if let notification = oneEvent as? UILocalNotification,
                userInfoCurrent = notification.userInfo as? [String:AnyObject],
                currentUID = userInfoCurrent["uid"] as? String {
                if currentUID == uid {
                    return notification
                }
            }
        }
        return nil
    }
    
    static func deleteLocalNotification(notification: UILocalNotification) {
        let app: UIApplication = UIApplication.sharedApplication()
        app.cancelLocalNotification(notification)
    }
    
    // MARK: Helpers
    
    private static func setUIDForNotification(notification: UILocalNotification, uid: String) {
        var userInfo = [String: String]()
        userInfo["UID"] = uid
        notification.userInfo = userInfo
    }
    
}
