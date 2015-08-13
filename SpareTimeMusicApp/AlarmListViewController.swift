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
        loadData()
        // Setup View
        setupView()
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
        let cell: AlarmRecordTableViewCell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! AlarmRecordTableViewCell
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
            let record: AlarmRecord = sender as! AlarmRecord
            let editVC = segue.destinationViewController as! EditAlarmTableViewController
            editVC.alarmRecord = record
        }
    }
    
    // MARK: Setup Views
    private func setupView() {
        // Setup Navigation
        setupNavigation()
        // Hide back button title
        hideBackButtonTitle()
        // Hide footer
        self.recordsTableView.tableFooterView = UIView(frame: CGRectZero)
        // Display Clock
        updateClock()
    }
    
    func updateClock() {
        self.clockView.setNeedsDisplay()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateClock"), userInfo: nil, repeats: false)
    }

    // MARK: Actions
    @IBAction func doneEditingAlarmRecord(segue:UIStoryboardSegue) {
        let editAlarmRecordVC = segue.sourceViewController as! EditAlarmTableViewController
        // Get created or edited alarm record from EditAlarmRecordVC
        self.workingRecord = editAlarmRecordVC.alarmRecord
        if let record = self.workingRecord {
            // Find which cell containing this record
            if let recordIndex = RecordHelper.getAlarmRecordIndexInAlarmArrays(self.alarmRecordArray, wantedObjectID: record.objectID) {
                // Update Alarm Array
                updateTableViewCell(record, recordIndex: recordIndex)
            } else {
                // Add new Cell
                insertTableViewCell(record)
            }
        }
    }

    private func updateTableViewCell(record: AlarmRecord, recordIndex: Int) {
        // Update Alarm Array
        loadData()
        // Update Cell
        self.updateTableViewCell(recordIndex, section: 0, tableView: self.recordsTableView, newAlarmRecord: record, coreDataHelper: self.cdh)
    }
    
    func insertTableViewCell(record: AlarmRecord) {
        // Update before add new cell
        loadData()
        // Find which cell containing this record
        if let recordIndex = RecordHelper.getAlarmRecordIndexInAlarmArrays(self.alarmRecordArray, wantedObjectID: record.objectID) {
            self.recordsTableView.beginUpdates()
            self.recordsTableView.insertRowsAtIndexPaths([NSIndexPath(forItem: recordIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
            self.recordsTableView.endUpdates()
        }
    }
}
