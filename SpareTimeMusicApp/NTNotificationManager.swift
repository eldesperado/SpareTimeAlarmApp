//
//  NTNotificationManager.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit
import Foundation

enum Notifications {
    enum Identity {
        case UID(timeStamp: String, date: NumberToDate?)
    }
    
    enum Properties: String {
        case Name = "Notification"
        case UID = "UID"
    }
    enum Categories: String {
        case Reminder = "Reminder"
    }
    
    enum Actions: String {
        case Snooze = "Snooze"
        case Dismiss = "Dismiss"
    }
}

struct NTNotificationManager {
    
    // MARK: Setup Notification
    func setupNotification() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if (notificationSettings.types == UIUserNotificationType.None) {
            // Specify the notification types.
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
            
            
            // Specify the notification actions.
            let dismissAction = UIMutableUserNotificationAction()
            dismissAction.identifier = Notifications.Actions.Dismiss.rawValue
            dismissAction.title = "Dismiss"
            dismissAction.activationMode = UIUserNotificationActivationMode.Background
            dismissAction.destructive = false
            dismissAction.authenticationRequired = false
            
            let snoozeAction = UIMutableUserNotificationAction()
            snoozeAction.identifier = Notifications.Actions.Snooze.rawValue
            snoozeAction.title = "Snooze"
            snoozeAction.activationMode = UIUserNotificationActivationMode.Background
            snoozeAction.destructive = false
            snoozeAction.authenticationRequired = false
            
            // Specify the category related to the above actions.
            let reminderCategory = UIMutableUserNotificationCategory()
            reminderCategory.identifier = Notifications.Categories.Reminder.rawValue
            reminderCategory.setActions([dismissAction, snoozeAction], forContext: .Default)
            reminderCategory.setActions([dismissAction, snoozeAction], forContext: .Minimal)
            
            let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: [reminderCategory])
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        }
    }
    
    // MARK: Create new notification
    func scheduleNewNotification(record: AlarmRecord) {
        // Convert RepeatDates NSManagedObject to an array containing all activated dates
        if let repeatDates: [Int] = RecordHelper.getRepeatDates(record) where repeatDates.count > 0 {
            // For each date in this AlarmRecord's RepeatDate array, create a seperated notification
            for repeatDate in repeatDates {
                if let dateNumber = NumberToDate(dateNumber: repeatDate) {
                    createLocalNotification(record, dateNumber: dateNumber.date)
                }
                
            }
        } else {
            // If this is an one-time alarm record
            createLocalNotification(record)
        }
    }
    
    func findExistedLocalNotification(uid: String, dateNumber: Int?) -> [UILocalNotification]? {
        // Make sure that scheduledLocalNotifications not nil
        guard let scheduledLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return nil }
        
        // Get Notification's Identity
        var numberToDate: NumberToDate?
        if let number = dateNumber {
            numberToDate = NumberToDate(dateNumber: number)
        }
        
        let uidString = "\(Notifications.Identity.UID(timeStamp: uid, date: numberToDate))"
        
        // Get current scheduled local notifications to find
        let foundNotificationArray = NSMutableArray()
        
        for notification in scheduledLocalNotifications {
            if let userInfoCurrent = notification.userInfo as? [String:AnyObject],
                notificationUID = userInfoCurrent[Notifications.Properties.UID.rawValue] as? String where notificationUID == uidString {
                    foundNotificationArray.addObject(notification)
            }
        }
        if let results = foundNotificationArray as NSArray as? [UILocalNotification] {
            return results
        } else {
            return nil
        }
    }
    
    func cancelLocalNotifications(record: AlarmRecord) {
        let repeatDates: [Int]? = RecordHelper.getRepeatDates(record)
        
        if let repeatDatesArray = repeatDates where repeatDatesArray.count > 0 {
            // For each date in this AlarmRecord's RepeatDate array, create a seperated notification
            for repeatDate in repeatDatesArray {
                // Cancel notification
                if let notification = findExistedLocalNotification(record.timeStamp, dateNumber: repeatDate) {
                    cancelLocalNotifications(notification)
                }
                
            }
        } else {
            // If this is an one-time alarm record
            if let notification = findExistedLocalNotification(record.timeStamp, dateNumber: nil) {
                cancelLocalNotifications(notification)
            }
        }
    }
    
    func cancelLocalNotifications(notifications: [UILocalNotification]) {
        for noti in notifications {
            cancelLocalNotification(noti)
        }
    }
    
    func cancelLocalNotification(notification: UILocalNotification) {
        // Cancel this notification
        UIApplication.sharedApplication().cancelLocalNotification(notification)
        // Also, remove this notification from NSUserDefaults
    }
    
    func handleNotificationActions(handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject]) {
        if let identifier = identifier, let action = Notifications.Actions(rawValue: identifier) {
            switch action {
            case .Dismiss:
                print("Dismiss!")
            case .Snooze:
                print("Snooze!")
            }

        } else {
            return
        }
        
    }
    
    // MARK: Helpers
    
    private func createLocalNotification(record: AlarmRecord, dateNumber: Int? = nil ) {
        // Check if existed a notification, if had, cancel it
        
        if let existedNoti = findExistedLocalNotification(record.timeStamp, dateNumber: dateNumber) {
            cancelLocalNotifications(existedNoti)
        }
        // Else create a new notification
        // Get Date
        let tempDate: NSDate
        
        if let date = dateNumber {
            tempDate = NSDate().change(weekday: date)

        } else {
            tempDate = NSDate()
        }
        let alarmTimeComponent = DateTimeHelper.getAlarmTimeComponents(alarmTime: record.alarmTime)
        
        let alarmDate = tempDate.change(hour: alarmTimeComponent.hour, minute: alarmTimeComponent.minutes, second: 0)
        
        let localNotification = UILocalNotification()
        localNotification.alertBody = record.salutationText
        localNotification.timeZone = NSTimeZone(name: "Asia/Ho_Chi_Minh")
        localNotification.fireDate = alarmDate
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        localNotification.repeatInterval = NSCalendarUnit.WeekOfYear
        
        localNotification.category = Notifications.Categories.Reminder.rawValue
        
        // Set UID for this notification
        setUIDForNotification(localNotification, uid: record.timeStamp, dateNumber: dateNumber)
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    private func setUIDForNotification(notification: UILocalNotification, uid: String, dateNumber: Int?) {
        var userInfo = [String: String]()
        var numberToDate: NumberToDate?
        if let number = dateNumber {
            numberToDate = NumberToDate(dateNumber: number)
        }
        
        userInfo[Notifications.Properties.UID.rawValue] = "\(Notifications.Identity.UID(timeStamp: uid, date: numberToDate))"
        notification.userInfo = userInfo
    }
    
}
