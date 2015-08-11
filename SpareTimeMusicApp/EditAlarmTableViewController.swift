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
    @IBOutlet weak private var salutationTextLabel: UILabel!
    @IBOutlet weak private var repeatRingtoneSwitch: NTSwitch!

    var alarmRecord: AlarmRecord?
    
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

    // MARK: Actions
    @IBAction func alarmTimePickerValueChanged(sender: AnyObject) {
    }
    
    func rightNavItemEditClick(sender: UIButton!) {
        
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
            
            // Get Repeat Dates as a String
            let repeatDateString = RecordHelper.getRepeatDatesString(record.repeatDates)
            // Set RepeatDate Label
            self.repeatDatesLabel.text = repeatDateString
            
            // Set Salutation Label
            self.salutationTextLabel.text = record.salutationText as String
            
            // Set Value for switch
            self.repeatRingtoneSwitch.on = record.isActive.boolValue
        } else {
            // Set Default values
            self.salutationTextLabel.text = ""
            self.repeatRingtoneSwitch.on = false
            // Set current time for time picker view
            let currentTime = DateTimeHelper.getCurrentTime()
            let currentTimeAsMinutes = DateTimeHelper.getMinutesForHoursMinutes(currentTime.hours, minutes: currentTime.minutes)
            self.alarmTimePickerView.setTimeIntervalAnimate(NSTimeInterval(currentTimeAsMinutes))
        }
    }
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.pushIdentifer {
            if let record: AlarmRecord = sender as? AlarmRecord {
                let repeatDateSelectionVC = segue.destinationViewController as! RepeatDateSelectionViewController
                repeatDateSelectionVC.repeatDates = record.repeatDates
            }
        }
    }
    
    // MARK: Setup View
    private func setupView() {
        // Hide Back Button Title
        hideBackButtonTitle()
        // Configure Navigation Bar Button Items
        configureNavigationBar()
    }
    
    // Configure Navigation Bar
    private func configureNavigationBar() {
        let buttonDone: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonDone.frame = CGRectMake(0, 0, 43, 30)
        buttonDone.setImage(UIImage(named:"done"), forState: UIControlState.Normal)
        buttonDone.addTarget(self, action: "rightNavItemEditClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItemDone: UIBarButtonItem = UIBarButtonItem(customView: buttonDone)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItemDone, animated: false)
    }

}
