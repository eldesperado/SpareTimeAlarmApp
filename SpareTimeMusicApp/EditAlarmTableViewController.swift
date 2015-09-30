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
    @IBOutlet weak var salutationTextField: FancyTextField!
    @IBOutlet weak private var repeatRingtoneSwitch: NTSwitch!

    var alarmRecord: AlarmRecord?
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
        }()
    
    // Private constant
    private let repeatDateCellLocationInTableView = 0
    private let ringToneCellLocationInTableView = 1
    private let salutationTextCellLocationInTableView = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Views
        setup()
        // Add Action for salutation Text field
        salutationTextField.actionWhenTextFieldDidBeginEditing = {[weak self] in self?.showBlurViewWhenEditTextField()}
        salutationTextField.actionWhenTextFieldDidEndEditing = {[weak self] in self?.hideBlurViewWhenEndEdittingTextField()}
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Update Navigation Title
        if alarmRecord == nil {
            navigationItem.title = "New Alarm"
        } else {
            navigationItem.title = "Edit Alarm"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Check whether alarmRecord variable has value or not, if not create a temporary new alarm record to create new alarm
        if alarmRecord == nil {
            alarmRecord = cdh.createTempAlarmRecord()
        }
    }
    
    // MARK: Actions    
    let unwindSegueId = "doneEditingAlarmUnwindSegue"
    @IBAction func doneBarButtonDidTouch(sender: AnyObject) {
        if let record = alarmRecord, backgroundObject = cdh.findRecordInBackgroundManagedObjectContext(record.objectID) as? AlarmRecord {
            // Update Alarm Record with new values
            cdh.updateAlarmRecord(backgroundObject, alarmTime: alarmTimePickerView.timeInterval, salutationText: salutationTextField.text, isRepeat: repeatRingtoneSwitch.isOn(), repeatDate: record.repeatDates)
            // Update alarmRecord
            alarmRecord = backgroundObject

            // Perform Unwind Segue
            performSegueWithIdentifier(unwindSegueId, sender: self)
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
        if indexPath.row == repeatDateCellLocationInTableView {
            performSegueWithIdentifier(pushIdentifer, sender: alarmRecord)
        }
    }
    
    // Setup
    private func setup() {
        // Setup View
        setupView()
        
        // Setup Cells
        if let record = alarmRecord {
            // Set Alarm Time
            alarmTimePickerView.setTimeIntervalAnimate(NSTimeInterval(record.alarmTime))
            
            // Set RepeatDate Label
            updateRepeatDateLabel(record.repeatDates)
            
            // Set Salutation Label
            salutationTextField.text = record.salutationText as String
            
            // Set Value for switch
            repeatRingtoneSwitch.on = record.isRepeat.boolValue
        } else {
            // Set Default values
            repeatDatesLabel.text = "Select Repeat Dates"
            ringtoneTypeStringLabel.text = "Select Ringtone Type"
            repeatRingtoneSwitch.on = false
            // Set current time for time picker view
            let currentTime = DateTimeHelper.getCurrentTime()
            let currentTimeAsMinutes = DateTimeHelper.getMinutesForHoursMinutes(currentTime.hours, minutes: currentTime.minutes)
            alarmTimePickerView.setTimeIntervalAnimate(NSTimeInterval(currentTimeAsMinutes))
        }
    }
    
    private func updateRepeatDateLabel(repeatDates: RepeatDate) {
        // Get Repeat Dates as a String
        let repeatDateString = RecordHelper.getRepeatDatesString(repeatDates)
        // Set RepeatDate Label
        repeatDatesLabel.text = repeatDateString
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == pushIdentifer {
            if let record: AlarmRecord = sender as? AlarmRecord,
            let backgroundRecord = cdh.findRecordInBackgroundManagedObjectContext(record.objectID) as? AlarmRecord,
            let repeatDateSelectionVC = segue.destinationViewController as? RepeatDateSelectionViewController
            {
                repeatDateSelectionVC.repeatDates = backgroundRecord.repeatDates
            }
        }
    }
    
    @IBAction func doneRepeatDatesSelectionUnwindSegue(segue:UIStoryboardSegue) {
        // Update Repeat Date TableViewCell
        // Update Repeat Dates
        if let repeatDatesSelectionVC = segue.sourceViewController as? RepeatDateSelectionViewController, record = alarmRecord where repeatDatesSelectionVC.repeatDates != nil {
            record.repeatDates.copyValueFrom(repeatDatesSelectionVC.repeatDates!)
            updateRepeatDateLabel(repeatDatesSelectionVC.repeatDates!)
        }
    }
    
    // MARK: Setup View
    private func setupView() {
        // Hide Back Button Title
        hideBackButtonTitle()
    }

    // MARK: Animation Closures
    let upperBlurViewTag: Int = 998
    let belowBlurViewTag: Int = 999
    func showBlurViewWhenEditTextField() {
        // Toggle navigation bar
        toggleNavigationbar(true)
        
        let textFieldCellRect = alarmSettingTableView.rectForRowAtIndexPath(NSIndexPath(forRow: salutationTextCellLocationInTableView, inSection: 0))
        // Add Upper Blur View
        let upperBlurView: UIView = UIView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(alarmSettingTableView.frame.width, textFieldCellRect.origin.y)))
        if let currentTheme = ThemeManager.getSharedInstance().stylesheet {
            if let backgroundColorString = currentTheme[ThemeComponent.ThemeAttribute.BackgroundColor] {
                let backgroundColor = UIColor(rgba: backgroundColorString)
                upperBlurView.backgroundColor = backgroundColor.colorWithAlphaComponent(0.9)

            }
        }
        upperBlurView.alpha = 0.9
        upperBlurView.tag = upperBlurViewTag
        upperBlurView.userInteractionEnabled = true
        upperBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideBlurViewWhenEndEdittingTextField"))
        view.addSubview(upperBlurView)
        
        // Add Below Blur View
        let belowBlurViewHeight = alarmSettingTableView.frame.size.height - textFieldCellRect.height - textFieldCellRect.origin.y
        let belowBlurViewY = textFieldCellRect.origin.y + textFieldCellRect.height
        let belowBlurView: UIView = UIView(frame: CGRect(origin: CGPointMake(0, belowBlurViewY), size: CGSizeMake(alarmSettingTableView.frame.width, belowBlurViewHeight)))
        belowBlurView.backgroundColor = upperBlurView.backgroundColor
        belowBlurView.alpha = 0.0
        belowBlurView.tag = belowBlurViewTag
        belowBlurView.userInteractionEnabled = true
        belowBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideBlurViewWhenEndEdittingTextField"))
        view.addSubview(belowBlurView)
        // Animate
        UIView.animateWithDuration(0.35, animations: {
            upperBlurView.alpha = 0.9
            belowBlurView.alpha = 0.9
            }, completion: { (completed) in
        
        })
    }
    
    func hideBlurViewWhenEndEdittingTextField() {
        UIView.animateWithDuration(0.3, animations: {
            if let upperBlurView: UIView = self.view.viewWithTag(self.upperBlurViewTag) {
                upperBlurView.alpha = 0
            }
            if let belowBlurView: UIView = self.view.viewWithTag(self.belowBlurViewTag) {
                belowBlurView.alpha = 0
            }
            }, completion: { [unowned self] (completed) in
                if let upperBlurView: UIView = self.view.viewWithTag(self.upperBlurViewTag) {
                    upperBlurView.removeFromSuperview()
                }
                if let belowBlurView: UIView = self.view.viewWithTag(self.belowBlurViewTag) {
                    belowBlurView.removeFromSuperview()
                }
                // Dimiss keyboard
                self.salutationTextField.resignFirstResponder()
                // Toggle navigation bar
                self.toggleNavigationbar(false)
   
        })
    }
    
    // MARK: Navigationbar
    @IBAction func toggleNavigationbar(status: Bool) {
        navigationController?.setNavigationBarHidden(status, animated: true) //or animated: false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

}
