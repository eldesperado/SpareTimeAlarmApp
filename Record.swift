//
//  Record.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/3/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation
import CoreData

class Record: NSManagedObject {

    @NSManaged var time: NSNumber
    @NSManaged var ringtoneType: NSNumber
    @NSManaged var salutationText: String
    @NSManaged var isRepeat: NSNumber
    @NSManaged var repeatDates: DateRepeat

}
