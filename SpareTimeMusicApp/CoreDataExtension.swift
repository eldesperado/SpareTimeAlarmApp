//
//  AlarmRecordExtension.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/13/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

infix operator ^^ { associativity left precedence 120 }
func ^^<T : BooleanType, U : BooleanType>(lhs: T, rhs: U) -> Bool {
    if lhs.boolValue == false && rhs.boolValue == false {
        return true
    } else {
        return lhs.boolValue != rhs.boolValue
    }
}

infix operator !^^ { associativity left precedence 120 }
func !^^<T : BooleanType, U : BooleanType>(lhs: T, rhs: U) -> Bool {
    return !(lhs.boolValue != rhs.boolValue)
}

extension AlarmRecord {
    func copyValueFrom(sourceRecord: AlarmRecord) {
        self.alarmTime = sourceRecord.alarmTime
        self.ringtoneType = sourceRecord.ringtoneType
        self.salutationText = sourceRecord.salutationText
        self.isRepeat = sourceRecord.isRepeat
        self.isActive = sourceRecord.isActive
        self.repeatDates.copyValueFrom(sourceRecord.repeatDates)
    }
    
}

func !=(left: AlarmRecord, right: AlarmRecord) -> Bool {
    let isDiffRepeatDates = (left.repeatDates != right.repeatDates)
    let isDiffAlarmTime = left.alarmTime != right.alarmTime
    let isDiffRingtoneType = left.ringtoneType != right.ringtoneType
    let isDiffSalutationText = left.salutationText != right.salutationText
    let isDiffIsRepeat = left.isRepeat != right.isRepeat
    let isDiffIsActive = left.isActive != right.isActive
    return (isDiffAlarmTime || isDiffRingtoneType || isDiffRingtoneType || isDiffSalutationText || isDiffIsRepeat || isDiffIsActive || isDiffRepeatDates)
}

func !=(left: RepeatDate, right: RepeatDate) -> Bool {
    return (left.isMon.boolValue ^^ right.isMon.boolValue)
        && (left.isTue.boolValue ^^ right.isTue.boolValue)
        && (left.isWed.boolValue ^^ right.isWed.boolValue)
        && (left.isThu.boolValue ^^ right.isThu.boolValue)
        && (left.isFri.boolValue ^^ right.isFri.boolValue)
        && (left.isSat.boolValue ^^ right.isSat.boolValue)
        && (left.isSun.boolValue ^^ right.isSun.boolValue)
}

extension RepeatDate {
    func copyValueFrom(source: RepeatDate) {
        self.isMon = source.isMon
        self.isTue = source.isTue
        self.isWed = source.isWed
        self.isThu = source.isThu
        self.isFri = source.isFri
        self.isSat = source.isSat
        self.isSun = source.isSun
    }
}
