//
//  DataHelper.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/9/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

// Enums
enum ClosestValueOptions {
    case OnlyEqualOrGreater
    case BothWays
}

struct DataHelper {
    
    static func findTheClosestValue(givenValue: NSNumber, numbers: [NSNumber], options: ClosestValueOptions) -> NSNumber {
        var minimumDifference: Int = Int.max
        var newDiff: Int = Int.max
        var closestNumber: NSNumber = NSNumber()
        for number in numbers {
            switch options {
            case .OnlyEqualOrGreater:
                if number.integerValue >= givenValue.integerValue {
                    newDiff = number.integerValue - givenValue.integerValue
                }
            case .BothWays:
                newDiff = abs(givenValue.integerValue - number.integerValue)
            }
            if newDiff < minimumDifference {
                minimumDifference = newDiff
                closestNumber = number
            }
        }
        return closestNumber
    }
}
