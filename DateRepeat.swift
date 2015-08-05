//
//  DateRepeat.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/3/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation
import CoreData

class DateRepeat: NSManagedObject {

    @NSManaged var mon: NSNumber
    @NSManaged var tue: NSNumber
    @NSManaged var wed: NSNumber
    @NSManaged var thu: NSNumber
    @NSManaged var fri: NSNumber
    @NSManaged var sat: NSNumber
    @NSManaged var sun: NSNumber
    @NSManaged var belongToRecord: NSManagedObject

}
