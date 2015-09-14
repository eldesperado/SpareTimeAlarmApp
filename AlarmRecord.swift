//
//  AlarmRecord.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation
import CoreData

@objc(AlarmRecord)
class AlarmRecord: NSManagedObject {

    @NSManaged var alarmTime: NSNumber
    @NSManaged var isActive: NSNumber
    @NSManaged var isRepeat: NSNumber
    @NSManaged var ringtoneType: NSNumber
    @NSManaged var salutationText: String
    @NSManaged var timeStamp: String
    @NSManaged var repeatDates: RepeatDate

}
