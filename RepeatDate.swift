//
//  RepeatDate.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation
import CoreData

@objc(RepeatDate)
class RepeatDate: NSManagedObject {

    @NSManaged var isFri: NSNumber
    @NSManaged var isMon: NSNumber
    @NSManaged var isSat: NSNumber
    @NSManaged var isSun: NSNumber
    @NSManaged var isThu: NSNumber
    @NSManaged var isTue: NSNumber
    @NSManaged var isWed: NSNumber
    @NSManaged var ofRecord: AlarmRecord

}
