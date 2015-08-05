//
//  Configuration.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/3/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation
import CoreData

class Configuration: NSManagedObject {

    @NSManaged var volume: NSNumber
    @NSManaged var style: NSNumber

}
