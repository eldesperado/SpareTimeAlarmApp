//
//  EditAlarmTableViewController.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/7/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class EditAlarmTableViewController: UITableViewController {
    
    @IBOutlet weak private var alarmTimePickerView: NTTimeIntervalPickerView!
    @IBOutlet weak private var alarmSettingTableView: UITableView!
    @IBOutlet weak private var repeatDatesLabel: UILabel!
    @IBOutlet weak private var ringtoneTypeStringLabel: UILabel!
    @IBOutlet weak var salutationTextField: UITextField!
    @IBOutlet weak private var repeatRingtoneSwitch: NTSwitch!

    var alarmRecord: AlarmRecord?
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
        }()
    
    // Private constant
    private let REPEAT_DATE_CELL: Int = 0
    private let RINGTONE_TYPE_CELL: Int = 1
    private let SALUTATION_TEXT_CELL: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Background image for table view
        self.alarmSettingTableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        // Hide footer
        self.alarmSettingTableView.tableFooterView = UIView(frame: CGRectZero)
        // Setup Views
        setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Update Navigation Title
        if alarmRecord == nil {
            self.navigationItem.title = "New Alarm"
        } else {
            self.navigationItem.title = "Edit Alarm"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Check whether alarmRecord variable has value or not, if not create a temporary new alarm record to create new alarm
        if self.alarmRecord == nil {
            self.alarmRecord = self.cdh.createTempAlarmRecord()
        }
    }
    
    // MARK: Actions
    @IBAction func alarmTimePickerValueChanged(sender: AnyObject) {
    }
    
    let unwindSegueId = "doneEditingAlarmUnwindSegue"
    @IBAction func doneBarButtonDidTouch(sender: AnyObject) {
        if let record = self.alarmRecord {
            let backgroundObject = self.cdh.findRecordInBackgroundManagedObjectContext(record.objectID) as! AlarmRecord
            // Update Alarm Record with new values
            backgroundObject.alarmTime = self.alarmTimePickerView.timeInterval
            backgroundObject.salutationText = self.salutationTextField.text
            backgroundObject.isRepeat = self.repeatRingtoneSwitch.isOn()
            backgroundObject.isActive = NSNumber(int: 1)
            backgroundObject.repeatDates.copyValueFrom(record.repeatDates)
            // Update alarmRecord
            self.alarmRecord = backgroundObject
            // Save new alarm
            self.cdh.saveContext()
            // Perform Unwind Segue
            self.performSegueWithIdentifier(self.unwindSegueId, sender: self)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 4
    }
    
    let pushIdentifer: String = "showRepeatDates"
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.REPEAT_DATE_CELL {
            performSegueWithIdentifier(self.pushIdentifer, sender: self.alarmRecord)
        }
    }
    
    // Setup
    private func setup() {
        // Setup View
        setupView()
        
        // Setup Cells
        if let record = self.alarmRecord {
            // Set Alarm Time
            self.alarmTimePickerView.setTimeIntervalAnimate(NSTimeInterval(record.alarmTime))
            
            // Set RepeatDate Label
            updateRepeatDateLabel(record.repeatDates)
            
            // Set Salutation Label
            self.salutationTextField.text = record.salutationText as String
            
            // Set Value for switch
            self.repeatRingtoneSwitch.on = record.isRepeat.boolValue
        } else {
            // Set Default values
            self.repeatDatesLabel.text = "Select Repeat Dates"
            self.ringtoneTypeStringLabel.text = "Select Ringtone Type"
            self.repeatRingtoneSwitch.on = false
            // Set current time for time picker view
            let currentTime = DateTimeHelper.getCurrentTime()
            let currentTimeAsMinutes = DateTimeHelper.getMinutesForHoursMinutes(currentTime.hours, minutes: currentTime.minutes)
            self.alarmTimePickerView.setTimeIntervalAnimate(NSTimeInterval(currentTimeAsMinutes))
        }
    }
    
    private func updateRepeatDateLabel(repeatDates: RepeatDate) {
        // Get Repeat Dates as a String
        let repeatDateString = RecordHelper.getRepeatDatesString(repeatDates)
        // Set RepeatDate Label
        self.repeatDatesLabel.text = repeatDateString
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.pushIdentifer {
            if let record: AlarmRecord = sender as? AlarmRecord {
                let backgroundRecord = self.cdh.findRecordInBackgroundManagedObjectContext(record.objectID) as! AlarmRecord
                let repeatDateSelectionVC = segue.destinationViewController as! RepeatDateSelectionViewController
                repeatDateSelectionVC.repeatDates = backgroundRecord.repeatDates
            }
        }
    }
    
    @IBAction func doneRepeatDatesSelectionUnwindSegue(segue:UIStoryboardSegue) {
        // Update Repeat Date TableViewCell
        let repeatDatesSelectionVC = segue.sourceViewController as! RepeatDateSelectionViewController
        updateRepeatDateLabel(repeatDatesSelectionVC.repeatDates!)
    }
    
    // MARK: Setup View
    private func setupView() {
        // Hide Back Button Title
        hideBackButtonTitle()
    }

}
