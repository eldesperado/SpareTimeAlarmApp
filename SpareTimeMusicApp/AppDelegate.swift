//
//  AppDelegate.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/3/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  // #pragma mark - Core Data Helper
  
  lazy var cdstore: CoreDataStore = {
    let cdstore = CoreDataStore()
    return cdstore
    }()
  
  lazy var cdh: CoreDataHelper = {
    let cdh = CoreDataHelper()
    return cdh
    }()
  
  lazy var notificationManager: NTNotificationManager = {
    let notificationManager = NTNotificationManager()
    return notificationManager
    }()
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    notificationManager.setupNotification()
    return true
  }
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    print("\(notification.userInfo) - \(notification.fireDate)")
  }
  
  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
    notificationManager.handleNotificationActions(handleActionWithIdentifier: identifier, forLocalNotification: notification, withResponseInfo: responseInfo)
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Save Background NSManagedObjectContext
    cdh.saveContext()
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Save Background NSManagedObjectContext
    cdh.saveContext()
  }
}

