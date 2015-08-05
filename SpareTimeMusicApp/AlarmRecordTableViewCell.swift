//
//  AlarmRecordTableViewCell.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/4/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit
import SevenSwitch

class AlarmRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmRepeatDatesLabel: UILabel!
    
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
    
    func configureCell(alarmTime time: NSNumber, repeatDates: String) {
        self.alarmTimeLabel.text = time.stringValue
        self.alarmRepeatDatesLabel.text = repeatDates
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
        
        let enableSwitch = NTSwitch()
        let switchTopPadding = (self.contentView.frame.height - enableSwitch.frame.height) / 2
        let switchRightPadding = self.contentView.frame.width - enableSwitch.frame.width - 13
        enableSwitch.frame = CGRect(origin: CGPointMake(switchRightPadding, switchTopPadding), size: enableSwitch.frame.size)
        self.addSubview(enableSwitch)
    }

}
