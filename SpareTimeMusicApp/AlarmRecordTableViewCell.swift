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
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    repeatRingtoneSwitch.subscribleToUpdateDependOnCurrentTheme()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func repeatRingtoneSwitchValueChanged(sender: AnyObject) {
    if let alarmRecord = record {
      if let cdh = coreDataHelper {
        // Update isRepeat shows that whether the ringtone is repeated or not
        // Find ManagedObject in background managed object context
        if let record = cdh.findRecordInBackgroundManagedObjectContext(alarmRecord.objectID) as? AlarmRecord {
          // Update value of isRepeat
          cdh.updateAlarmRecord(record, isRepeat: repeatRingtoneSwitch.isOn())
        }
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
    alarmTimeLabel.text = alarmString
    
    // Get Repeat Dates as a String
    let repeatDateString = RecordHelper.getRepeatDatesString(record.repeatDates)
    alarmRepeatDatesLabel.text = repeatDateString
    
    // Set Value for switch
    repeatRingtoneSwitch.on = record.isRepeat.boolValue
  }
  
  override func setupCellViews() {
    super.setupCellViews()
    let rightSeperatorPaddingConstant: CGFloat = 0.52
    let rightSeperatorTopPadding = contentView.frame.height * (1.0 - rightSeperatorPaddingConstant) / 2.0
    let rightSeparator = UIView(frame: CGRectMake(contentView.frame.size.width - 1, rightSeperatorTopPadding, 1.0, contentView.frame.height * rightSeperatorPaddingConstant))
    rightSeparator.backgroundColor = separatorColour
    addSubview(rightSeparator)
  }
  
  deinit {
    ThemeObserver.unregister(self)
  }
}
