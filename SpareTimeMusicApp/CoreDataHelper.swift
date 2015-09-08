//
//  CoreDataHelper.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/5/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataOperation {
    // FETCH: Fetches AlarmRecord table's records
    func listAllAlarmRecordsMostRecently() -> [AlarmRecord]?
    func listAllActiveAlarmRecordsMostRecently() -> [AlarmRecord]?
    func listAlarmRecords(listingParameters parameters: CoreDataHelper.ListingParameters) -> [AlarmRecord]?
    // INSERT: Insert AlarmRecord table's records in background
    func insertAlarmRecord(alarmTime: NSNumber, ringtoneType: NSNumber, salutationText: String?, isRepeat: Bool, repeatDate: RepeatDate?)
    // DELETE: Delete AlarmRecord and RepeatDate in cascade
    func deleteAlarmRecord(alarmRecord record: AlarmRecord)
}


class CoreDataHelper: NSObject, CoreDataOperation {
    let store: CoreDataStore!
    
    override init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.store = appDelegate.cdstore
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveContext:", name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // #pragma mark - Core Data stack
    // Returns the managed object context for the application.
    // But for bulk data update, acording to Florian Kugler's blog about core data performance, [Concurrent Core Data Stacks – Performance Shootout](http://floriankugler.com/blog/2013/4/29/concurrent-core-data-stack-performance-shootout) and [Backstage with Nested Managed Object Contexts](http://floriankugler.com/blog/2013/5/11/backstage-with-nested-managed-object-contexts). We should better write data in background context. and read data from main queue context.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    // Main thread context
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.store.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // Returns the background object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    lazy var backgroundContext: NSManagedObjectContext? = {
        let coordinator = self.store.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // Save Context
    func saveContext(managedObjectContext context: NSManagedObjectContext) {
        var error: NSError? = nil
        if context.hasChanges && !context.save(&error) {
            // FIXME: Create an appropritely way to handle this error
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }
    
    func saveContext() {
        if let context = self.backgroundContext {
            saveContext(managedObjectContext: context)
        } else {
            // FIXME: Create an appropritely way to handle this error
            NSLog("Cannot save background context")
        }
    }
    
    // call back function by saveContext, support multi-thread
    func contextDidSaveContext(notification: NSNotification) {
        if let sender = notification.object as? NSManagedObjectContext {
            if sender === self.managedObjectContext {
                NSLog("******** Saved main Context in this thread")
                self.backgroundContext!.performBlock {
                    self.backgroundContext!.mergeChangesFromContextDidSaveNotification(notification)
                }
            } else if sender === self.backgroundContext {
                NSLog("******** Saved background Context in this thread")
                self.managedObjectContext!.performBlock {
                    self.managedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
                }
            } else {
                NSLog("******** Saved Context in other thread")
                self.backgroundContext!.performBlock {
                    self.backgroundContext!.mergeChangesFromContextDidSaveNotification(notification)
                }
                self.managedObjectContext!.performBlock {
                    self.managedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
                }
        }
        }
    }
}
