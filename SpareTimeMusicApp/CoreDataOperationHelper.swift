//
//  CoreDataOperationHelper.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/6/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import CoreData
import Foundation

enum EntityTableName: String {
    case AlarmRecord = "AlarmRecord"
    case RepeatDate = "RepeatDate"
}


struct RecordHelper {
    static func getRepeatDatesString(repeatDates: RepeatDate) -> String {
        // Get Current Date
        let currentDay = DateTimeHelper.getCurrentDate().dayOfWeek

        var string = ""
        // FIXME: Please fix this ugly code
        if repeatDates.isMon.boolValue {
            if currentDay == 2 {
                string += "Today"
            } else {
                string += "Mon"
            }
        }
        if repeatDates.isTue.boolValue {
            if currentDay == 3 {
                string += ", Today"
            } else {
                string += ", Tue"
            }

        }
        if repeatDates.isWed.boolValue {
            if currentDay == 4 {
                string += ", Today"
            } else {
                string += ", Wed"
            }
        }
        if repeatDates.isThu.boolValue {
            if currentDay == 5 {
                string += ", Today"
            } else {
                string += ", Thu"
            }
        }
        if repeatDates.isFri.boolValue {
            if currentDay == 6 {
                string += ", Today"
            } else {
                string += ", Fri"
            }
        }
        if repeatDates.isSat.boolValue {
            if currentDay == 7 {
                string += ", Today"
            } else {
                string += ", Sat"
            }
        }
        if repeatDates.isSun.boolValue {
            if currentDay == 8 {
                string += ", Today"
            } else {
                string += ", Sun"
            }
        }

        // Check whether this string is empty or not. If empty, return "No Repeat" string
        if string.isEmpty {
            return "No Repeat"
        }
        // Check whether this string begins with " ," characters. If does, remove
        if string.hasPrefix(", ") {
            string.removeRange(string.startIndex...advance(string.startIndex, 1))
        }
        // Check whether this string contains all dates, that means there are 7 Date strings. If does, return "Everyday"
        if self.countStringsSeparateByColon(string) == 7 {
            return "Everyday"
        }
        return string
    }
    
    private static func countStringsSeparateByColon(string: String) -> Int {
        var number: Int = 0
        let strings = split(string, isSeparator: { $0 == ","})
        return strings.count
    }
    
    static func getAlarmRecordIndexInAlarmArrays(alarmArray: [AlarmRecord], timeStamp: String) -> Int? {
        var i = 0
        for record in alarmArray {
            if record.timeStamp == timeStamp {
                return i
            }
            i++
        }
        return nil
    }
    
    // Convert RepeatDates NSManagedObject to an array containing all activated dates
    static func getRepeatDates(alarmRecord: AlarmRecord) -> [Int]? {
        let repeatDates = alarmRecord.repeatDates
        var dates = NSMutableArray()
        
        if (repeatDates.isSun.boolValue) {
            dates.addObject(NumberToDate.Sunday.date)
        }
        if (repeatDates.isMon.boolValue) {
            dates.addObject(NumberToDate.Monday.date)
        }
        if (repeatDates.isTue.boolValue) {
            dates.addObject(NumberToDate.Tuesday.date)
        }
        if (repeatDates.isWed.boolValue) {
            dates.addObject(NumberToDate.Wednesday.date)
        }
        if (repeatDates.isThu.boolValue) {
            dates.addObject(NumberToDate.Thursday.date)
        }
        if (repeatDates.isFri.boolValue) {
            dates.addObject(NumberToDate.Friday.date)
        }
        if (repeatDates.isSat.boolValue) {
            dates.addObject(NumberToDate.Saturday.date)
        }
        
        if let array = dates as NSArray as? [Int] {
            return array
        } else {
            return nil
        }
    }
}

extension CoreDataHelper {
    // value of value types for function listAlarmRecords() (read more: https://realm.io/news/andy-matuschak-controlling-complexity/)
    struct ListingParameters {
        var sortDescriptor: NSSortDescriptor?
        var predicateFilter: NSPredicate?
    }
    
    // MARK: AlarmRecord Table
    // MARK: FETCH: Fetches AlarmRecord table's records

    func listAllAlarmRecordsMostRecently() -> [AlarmRecord]? {
        // Create option
        let sortDescriptor = NSSortDescriptor(key: "alarmTime" , ascending: false)
        let options = ListingParameters(sortDescriptor: sortDescriptor, predicateFilter: nil)
        return listAlarmRecords(listingParameters: options)
    }
    
    func listAllActiveAlarmRecordsMostRecently() -> [AlarmRecord]? {
        // Create option
        let sortDescriptor = NSSortDescriptor(key: "alarmTime" , ascending: true)
        let predicate = NSPredicate(format: "isActive == true")
        let options = ListingParameters(sortDescriptor: sortDescriptor, predicateFilter: predicate)
        return listAlarmRecords(listingParameters: options)
    }
    
    func listAlarmRecords(listingParameters parameters: ListingParameters) -> [AlarmRecord]? {
        let fetchReq : NSFetchRequest = NSFetchRequest(entityName: EntityTableName.AlarmRecord.rawValue)
        var error: NSError? = nil
        
        if let predicate = parameters.predicateFilter {
            fetchReq.predicate = predicate
        }
        
        if let sortDes = parameters.sortDescriptor {
            fetchReq.sortDescriptors = [sortDes]
        }
        
        fetchReq.returnsObjectsAsFaults = false
        
        let result = self.managedObjectContext!.executeFetchRequest(fetchReq, error: &error)
        if (error != nil) {
            // FIXME: Create an appropriately way to handle this error!
            return nil
        }
        
        return result as? [AlarmRecord]
    }
    
    
    
    // MARK: INSERT: Insert AlarmRecord table's records in background
    func createTempAlarmRecord() -> AlarmRecord {
        var newRecord: AlarmRecord = NSEntityDescription.insertNewObjectForEntityForName(EntityTableName.AlarmRecord.rawValue, inManagedObjectContext: self.backgroundContext!) as! AlarmRecord
        var newRDates: RepeatDate = NSEntityDescription.insertNewObjectForEntityForName(EntityTableName.RepeatDate.rawValue, inManagedObjectContext: self.backgroundContext!) as! RepeatDate
        let val = 0
        newRDates.isMon = val
        newRDates.isTue = val
        newRDates.isWed = val
        newRDates.isThu = val
        newRDates.isFri = val
        newRDates.isSat = val
        newRDates.isSun = val
        newRDates.ofRecord = newRecord
        newRecord.repeatDates = newRDates

        // Set TimeStamp as UID
        self.setTimeStamp(newRecord)
        
        return newRecord
    }
    
    func insertAlarmRecord(alarmTime: NSNumber, ringtoneType: NSNumber, salutationText: String? = "", isRepeat: Bool, repeatDate: RepeatDate?) {
        
        var newRecord: AlarmRecord = NSEntityDescription.insertNewObjectForEntityForName(EntityTableName.AlarmRecord.rawValue, inManagedObjectContext: self.backgroundContext!) as! AlarmRecord
        newRecord.alarmTime = alarmTime
        newRecord.ringtoneType = ringtoneType
        if let saluStr = salutationText {
            newRecord.salutationText = saluStr
        }
        newRecord.isRepeat = isRepeat
        newRecord.isActive = NSNumber(int: 1)
        if repeatDate == nil {
            var newRDates: RepeatDate = NSEntityDescription.insertNewObjectForEntityForName(EntityTableName.RepeatDate.rawValue, inManagedObjectContext: self.backgroundContext!) as! RepeatDate
            let val = 1
            newRDates.isMon = val
            newRDates.isTue = val
            newRDates.isWed = val
            newRDates.isThu = val
            newRDates.isFri = val
            newRDates.isSat = val
            newRDates.isSun = val
            newRDates.ofRecord = newRecord
            newRecord.repeatDates = newRDates
        }
        
        // Set TimeStamp as UID
        self.setTimeStamp(newRecord)
        
        // Save in background thread
        self.saveContext()
        
        // Create a notification
        self.notificationManager.scheduleNewNotification(newRecord)
    }
    
    func updateAlarmRecord(record: AlarmRecord, alarmTime: NSNumber? = nil, ringtoneType: NSNumber? = nil, salutationText: String? = "", isRepeat: Bool? = nil, isActive: Bool? = true, repeatDate: RepeatDate? = nil) {
        
        // Update Alarm Record with new values
        if let alTime = alarmTime {
            record.alarmTime = alTime
        }
        if let rType = ringtoneType {
            record.ringtoneType = rType
        }
        
        if let text = salutationText {
            record.salutationText = text
        }
        
        if let repeat = isRepeat {
            record.isRepeat = repeat
        }
        
        if let active = isActive {
            record.isActive = active
        }
        
        if let rDates = repeatDate {
            record.repeatDates.copyValueFrom(rDates)
        }
        
        // Save new alarm
        self.saveContext()
        // Create a notification
        self.notificationManager.scheduleNewNotification(record)

    }
    
    // MARK: Find object
    func findRecordInBackgroundManagedObjectContext(managedObjectId: NSManagedObjectID) -> NSManagedObject {
        return findRecord(managedObjectId, managedObjectContext: self.backgroundContext!)
    }
    
    func findRecord(managedObjectId: NSManagedObjectID, managedObjectContext: NSManagedObjectContext) -> NSManagedObject {
        let managedObject = managedObjectContext.objectWithID(managedObjectId)
        return managedObject
    }
    
    // MARK: DELETE: Delete AlarmRecord and RepeatDate in cascade
    func deleteAlarmRecord(alarmRecord record: AlarmRecord) {
        let recordTimeStamp: String = record.timeStamp
        
        // Cancel location notifications
        self.notificationManager.cancelLocalNotifications(record)
        
        // Find this object in background managed object context
        let managedObject = findRecord(record.objectID, managedObjectContext: self.backgroundContext!)
        self.backgroundContext!.deleteObject(managedObject)
        // Save in background thread
        self.saveContext()
    }
    
    // MARK: Helpers
    private func setTimeStamp(record: AlarmRecord) {
        let now = NSDate()
        let time = Int(now.timeIntervalSince1970 * 1000)
        record.timeStamp = "\(time)"
    }
    
}
