//
//  AlarmRecordTableViewCell.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/4/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class AlarmRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmRepeatDatesLabel: UILabel!
    @IBOutlet weak var repeatRingtoneSwitch: NTSwitch!
    
    private var record: AlarmRecord?
    // Dependency Injection Pattern
    private var coreDataHelper: CoreDataHelper?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func repeatRingtoneSwitchValueChanged(sender: AnyObject) {
        if let alarmRecord = self.record {
            if let cdh = self.coreDataHelper {
                // Update isRepeat shows that whether the ringtone is repeated or not
                // Find ManagedObject in background managed object context
                let record = cdh.findRecordInBackgroundManagedObjectContext(alarmRecord.objectID) as! AlarmRecord
                // Update boolean value
                record.isRepeat = self.repeatRingtoneSwitch.isOn()
                // Save context
                self.coreDataHelper!.saveContext()
            }
        }
    }
    
    
    func configureCell(alarmRecord record: AlarmRecord, coreDataHelper: CoreDataHelper) {
        // Store AlarmRecord
        self.record = record
        // Assign CoreDataHelper
        self.coreDataHelper = coreDataHelper
        // Get Alarm Time as a String
        let alarmString = DateTimeHelper.getAlarmTime(alarmTime: record.alarmTime)
        self.alarmTimeLabel.text = alarmString
        
        // Get Repeat Dates as a String
        let repeatDateString = RecordHelper.getRepeatDatesString(record.repeatDates)
        self.alarmRepeatDatesLabel.text = repeatDateString
        
        // Set Value for switch
        self.repeatRingtoneSwitch.on = record.isRepeat.boolValue
        // Update View
        setupCellViews()
    }
    
    override func setupCellViews() {
        super.setupCellViews()
        let rightSeperatorPaddingConstant: CGFloat = 0.52
        let rightSeperatorTopPadding = self.contentView.frame.height * (1.0 - rightSeperatorPaddingConstant) / 2.0
        let rightSeparator = UIView(frame: CGRectMake(self.contentView.frame.size.width - 1, rightSeperatorTopPadding, 1.0, self.contentView.frame.height * rightSeperatorPaddingConstant))
        rightSeparator.backgroundColor = separatorColour
        self.addSubview(rightSeparator)
    }
}
