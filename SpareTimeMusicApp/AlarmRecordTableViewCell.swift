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
    let enableSwitch = NTSwitch()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(alarmRecord record: AlarmRecord) {
        // Get Alarm Time as a String
        let alarmString = RecordHelper.getAlarmTime(alarmTime: record.alarmTime)
        self.alarmTimeLabel.text = alarmString
        
        // Get Repeat Dates as a String
        let repeatDateString = RecordHelper.getRepeatDatesString(record.repeatDates)
        self.alarmRepeatDatesLabel.text = repeatDateString
        
        // Set Value for switch
        self.enableSwitch.on = record.isActive.boolValue
        
        // FIXME: Move to another function
        // Add Separator
        let topSeparator = UIView(frame: CGRectMake(0, 1.0, self.contentView.frame.size.width, 1))
        let rightSeperatorPaddingConstant: CGFloat = 0.52
        let rightSeperatorTopPadding = self.contentView.frame.height * (1.0 - rightSeperatorPaddingConstant) / 2.0
        let rightSeparator = UIView(frame: CGRectMake(self.contentView.frame.size.width - 1, rightSeperatorTopPadding, 1.0, self.contentView.frame.height * rightSeperatorPaddingConstant))
        topSeparator.backgroundColor = UIColor(white: 1, alpha: 0.15)
        rightSeparator.backgroundColor = topSeparator.backgroundColor
        self.addSubview(topSeparator)
        self.addSubview(rightSeparator)
        
        let switchTopPadding = (self.contentView.frame.height - self.enableSwitch.frame.height) / 2
        let switchRightPadding = self.contentView.frame.width - self.enableSwitch.frame.width - 13
        self.enableSwitch.frame = CGRect(origin: CGPointMake(switchRightPadding, switchTopPadding), size: self.enableSwitch.frame.size)
        self.addSubview(self.enableSwitch)
    }

}
