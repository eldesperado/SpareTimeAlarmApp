//
//  CoreDataOperationHelper.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/6/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import CoreData

enum EntityTableName: String {
    case AlarmRecord = "AlarmRecord"
    case RepeatDate = "RepeatDate"
}


struct RecordHelper {
    static func getRepeatDatesString(repeatDates: RepeatDate) -> String {
        var string = ""
        if repeatDates.isMon.boolValue {
            string += "Mon"
        }
        if repeatDates.isTue.boolValue {
            string += ", Tue"
        }
        if repeatDates.isWed.boolValue {
            string += ", Wed"
        }
        if repeatDates.isThu.boolValue {
            string += ", Thu"
        }
        if repeatDates.isFri.boolValue {
            string += ", Fri"
        }
        if repeatDates.isSat.boolValue {
            string += ", Sat"
        }
        if repeatDates.isSun.boolValue {
            string += ", Sun"
        }
        if string == "Mon, Tue, Wed, Thu, Fri, Sat, Sun" {
            return "Everyday"
        }
        if string.isEmpty {
            return "No Repeat"
        }
        if string.hasPrefix(", ") {
            string.removeRange(string.startIndex...advance(string.startIndex, 1))
        }
        return string
    }
    
    static func getAlarmTime(let alarmTime time: NSNumber) -> String {
        let hour = time.integerValue / 360
        let minute = time.integerValue % 60
        return "\(hour):\(minute)"
    }
}

extension CoreDataHelper {
    // value of value types for function listAlarmRecords() (read more: https://realm.io/news/andy-matuschak-controlling-complexity/)
    struct ListingParameters {
        var sortDescriptor: NSSortDescriptor?
        var predicateFilter: NSPredicate?
    }
    
    // pragmark: AlarmRecord Table
    // FETCH: Fetches AlarmRecord table's records

    func listAllAlarmRecordsMostRecently() -> [AlarmRecord]? {
        // Create option
        let sortDescriptor = NSSortDescriptor(key: "alarmTime" , ascending: false)
        let options = ListingParameters(sortDescriptor: sortDescriptor, predicateFilter: nil)
        return listAlarmRecords(listingParameters: options)
    }
    
    func listAllActiveAlarmRecordsMostRecently() -> [AlarmRecord]? {
        // Create option
        let sortDescriptor = NSSortDescriptor(key: "alarmTime" , ascending: false)
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
    
    // INSERT: Insert AlarmRecord table's records in background
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
        
        // Save in background thread
        self.saveContext()
    }
}
