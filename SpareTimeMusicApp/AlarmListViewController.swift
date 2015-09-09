 //
//  AlarmListViewController.swift
//  SpareTimeMusicApp
//
//  Created by Pham Nguyen Nhat Trung on 8/4/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class AlarmListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var recordsTableView: UITableView!
    @IBOutlet weak var timeToWakeUpLabel: UILabel!
    
    var timer = NSTimer()
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
        }()
    
    var alarmRecordArray: [AlarmRecord]!
    var workingRecord: AlarmRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load Data
        self.loadData()
        // Setup View
        self.setupView()
        // Animate Cell Loading
        if self.alarmRecordArray.count > 0 {
            self.recordsTableView.reloadDataWithAnimation(UITableViewCellLoadingAnimations.AnimationCellDirection.LiftUpFromBottom, animationTime: 0.5, interval: 0.05)
        }
    }
    
    func loadData() {
        if self.alarmRecordArray != nil {
            self.alarmRecordArray = nil
        }
        self.alarmRecordArray = self.cdh.listAllActiveAlarmRecordsMostRecently()
    }
    
    // MARK: UITableViewDelegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmRecordArray.count
    }
    
    let textCellIdentifier = "alarmRecordCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AlarmRecordTableViewCell
        if let dequeCell: AlarmRecordTableViewCell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as?AlarmRecordTableViewCell {
            cell = dequeCell
        } else {
            cell = AlarmRecordTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: textCellIdentifier)
        }
        
        let record: AlarmRecord = alarmRecordArray[indexPath.row]
        // Configure Cell
        cell.configureCell(alarmRecord: record, coreDataHelper: self.cdh)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    let pushIdentifer: String = "configureAlarmRecord"
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let setting = UITableViewRowAction(style: .Normal, title: "Setting") { (action, index) -> Void in
            // Push data to EditAlarmRecordTableViewController
            let record: AlarmRecord = self.alarmRecordArray[indexPath.row]
            self.performSegueWithIdentifier(self.pushIdentifer, sender: record)
        }
        setting.backgroundColor = UIColor.clearColor()
        let remove = UITableViewRowAction(style: .Normal, title: "Remove") { (action, index) -> Void in
            let record: AlarmRecord = self.alarmRecordArray[indexPath.row]
            // Delete this record
            self.cdh.deleteAlarmRecord(alarmRecord: record)
            // Update Array
            self.alarmRecordArray.removeAtIndex(indexPath.row)
            // Animate the removal of the row
            self.recordsTableView.beginUpdates()
            self.recordsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            self.recordsTableView.endUpdates()
        }
        remove.backgroundColor = UIColor.clearColor()
        return [setting, remove]
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.pushIdentifer {
            if let record: AlarmRecord = sender as? AlarmRecord, editVC = segue.destinationViewController as? EditAlarmTableViewController {
                editVC.alarmRecord = record
            }
        }
    }
    
    
    // MARK: Setup Views
    private func setupView() {
        // Setup Navigation
        self.setupNavigation()
        // Hide back button title
        self.hideBackButtonTitle()
        // Hide footer
        self.recordsTableView.tableFooterView = UIView(frame: CGRectZero)
        // Display Clock
        self.updateClock()
        // Update TimeToWakeUpLabel
        self.updateTimeToWakeUpLabel()
    }
    
    func updateClock() {
        // Redraw clock
        self.clockView.setNeedsDisplay()
        // In every 60 seconds, we update TimeToWakeUp Label
        if DateTimeHelper.getCurrentTimeInSeconds().integerValue % 60 == 0 {
            // Reupdate TimeToWakeUpLabel
            self.updateTimeToWakeUpLabel()
        }

        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateClock"), userInfo: nil, repeats: false)
    }
    
    private func updateTimeToWakeUpLabel() {
        // If there are some alarm records, then
        if !self.alarmRecordArray.isEmpty {
            // Get all Alarm Time
            let alarmTimeArray = self.alarmRecordArray.map{ (record: AlarmRecord) in
                record.alarmTime
                }
            // Find the closest alarm time from the current time
            let currentTimesInMinutes = DateTimeHelper.getCurrentTimeInMinutes()
            let closestAlarmTime = DataHelper.findTheClosestValue(currentTimesInMinutes, numbers: alarmTimeArray, options: ClosestValueOptions.OnlyEqualOrGreater)
            
            let closestAlarmTimeAsString = DateTimeHelper.getAlarmTime(alarmTime: closestAlarmTime)
            
            self.timeToWakeUpLabel.text =  "Time to wake UP - \(closestAlarmTimeAsString)"
        }
    }

    // MARK: Actions
    @IBAction func doneEditingAlarmRecord(segue:UIStoryboardSegue) {
        if let editAlarmRecordVC = segue.sourceViewController as? EditAlarmTableViewController {
            // Get created or edited alarm record from EditAlarmRecordVC
            self.workingRecord = editAlarmRecordVC.alarmRecord
            if let record = self.workingRecord {
                // Find which cell containing this record
                if let recordIndex = RecordHelper.getAlarmRecordIndexInAlarmArrays(self.alarmRecordArray, wantedObjectID: record.objectID) {
                    // Update Alarm Array
                    self.updateTableViewCell(record, recordIndex: recordIndex)
                } else {
                    // Add new Cell
                    self.insertTableViewCell(record)
                }
                // Update TimeToWakeUpLabel
                self.updateTimeToWakeUpLabel()
            }
        }
    }

    private func updateTableViewCell(record: AlarmRecord, recordIndex: Int) {
        // Update Alarm Array
        self.loadData()
        // Update Cell
        self.updateTableViewCell(recordIndex, section: 0, tableView: self.recordsTableView, newAlarmRecord: record, coreDataHelper: self.cdh)
    }
    
    private func insertTableViewCell(record: AlarmRecord) {
        // Update before add new cell
        self.loadData()
        // Find which cell containing this record
        if let recordIndex = RecordHelper.getAlarmRecordIndexInAlarmArrays(self.alarmRecordArray, wantedObjectID: record.objectID) {
            self.recordsTableView.beginUpdates()
            self.recordsTableView.insertRowsAtIndexPaths([NSIndexPath(forItem: recordIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
            self.recordsTableView.endUpdates()
        }
    }
    
    // MARK: Deinit
    deinit {
        ThemeObserver.unregister(self)
    }
}
