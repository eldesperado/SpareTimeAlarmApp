//
//  DataHelper.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/9/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

struct DataHelper {
    static func findTheClosestValue(givenValue: NSNumber, numbers: [NSNumber]) -> NSNumber {
        var minimumDifference: Int = Int.max
        var newDiff: Int = Int.max
        var closestNumber: NSNumber = NSNumber()
        for number in numbers {
            newDiff = abs(givenValue.integerValue - number.integerValue)
            if newDiff < minimumDifference {
                minimumDifference = newDiff
                closestNumber = number
            }
        }
        return closestNumber
    }
}
