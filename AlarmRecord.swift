//
//  AlarmRecord.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/6/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation
import CoreData

@objc(AlarmRecord)
class AlarmRecord: NSManagedObject {

    @NSManaged var alarmTime: NSNumber
    @NSManaged var ringtoneType: NSNumber
    @NSManaged var salutationText: String
    @NSManaged var isRepeat: NSNumber
    @NSManaged var isActive: NSNumber
    @NSManaged var repeatDates: RepeatDate

}
