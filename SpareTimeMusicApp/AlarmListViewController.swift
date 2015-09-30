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
  
  var alarmRecordArray: [AlarmRecord]?
  var workingRecord: AlarmRecord?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Load Data
    loadData()
    // Setup View
    setupView()
    // Animate Cell Loading
    if let dataArray = alarmRecordArray where dataArray.count > 0 {
      recordsTableView.reloadDataWithAnimation(UITableViewCellLoadingAnimations.AnimationCellDirection.LiftUpFromBottom, animationTime: 0.5, interval: 0.05)
    }
    
  }
  
  func loadData() {
    if alarmRecordArray != nil {
      alarmRecordArray = nil
    }
    alarmRecordArray = cdh.listAllActiveAlarmRecordsMostRecently()
  }
  
  // MARK: UITableViewDelegates
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let dataArray = alarmRecordArray {
      return dataArray.count
    } else {
      return 0
    }
  }
  
  let textCellIdentifier = "alarmRecordCell"
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let dataArray = alarmRecordArray else { fatalError("AlarmRecord Array is nil") }
    
    let cell: AlarmRecordTableViewCell
    if let dequeCell: AlarmRecordTableViewCell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as?AlarmRecordTableViewCell {
      cell = dequeCell
    } else {
      cell = AlarmRecordTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: textCellIdentifier)
    }
    
    let record: AlarmRecord = dataArray[indexPath.row]
    // Configure Cell
    cell.configureCell(alarmRecord: record, coreDataHelper: cdh)
    
    return cell
  }
  
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  let pushIdentifer: String = "configureAlarmRecord"
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    guard var dataArray = alarmRecordArray else { fatalError("AlarmRecord Array is nil") }
    
    let setting = UITableViewRowAction(style: .Normal, title: "Setting") { [unowned self] (action, index) -> Void in
      // Push data to EditAlarmRecordTableViewController
      let record: AlarmRecord = dataArray[indexPath.row]
      self.performSegueWithIdentifier(self.pushIdentifer, sender: record)
    }
    setting.backgroundColor = UIColor.clearColor()
    let remove = UITableViewRowAction(style: .Normal, title: "Remove") { [unowned self] (action, index) -> Void in
      let record: AlarmRecord = dataArray[indexPath.row]
      // Delete this record
      self.cdh.deleteAlarmRecord(alarmRecord: record)
      // Update Array
      dataArray.removeAtIndex(indexPath.row)
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
    if segue.identifier == pushIdentifer {
      if let record: AlarmRecord = sender as? AlarmRecord, editVC = segue.destinationViewController as? EditAlarmTableViewController {
        editVC.alarmRecord = record
      }
    }
  }
  
  
  // MARK: Setup Views
  private func setupView() {
    // Setup Navigation
    setupNavigation()
    // Hide back button title
    hideBackButtonTitle()
    // Hide footer
    recordsTableView.tableFooterView = UIView(frame: CGRectZero)
    // Display Clock
    updateClock()
    // Update TimeToWakeUpLabel
    updateTimeToWakeUpLabel()
  }
  
  func updateClock() {
    // Redraw clock
    clockView.setNeedsDisplay()
    // In every 60 seconds, we update TimeToWakeUp Label
    if DateTimeHelper.getCurrentTimeInSeconds().integerValue % 60 == 0 {
      // Reupdate TimeToWakeUpLabel
      updateTimeToWakeUpLabel()
    }
    
    timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateClock"), userInfo: nil, repeats: false)
  }
  
  private func updateTimeToWakeUpLabel() {
    // If there are some alarm records, then
    if let dataArray = alarmRecordArray where dataArray.isEmpty {
      // Get all Alarm Time
      let alarmTimeArray = dataArray.map{ (record: AlarmRecord) in
        record.alarmTime
      }
      // Find the closest alarm time from the current time
      let currentTimesInMinutes = DateTimeHelper.getCurrentTimeInMinutes()
      let closestAlarmTime = DataHelper.findTheClosestValue(currentTimesInMinutes, numbers: alarmTimeArray, options: ClosestValueOptions.OnlyEqualOrGreater)
      
      let closestAlarmTimeAsString = DateTimeHelper.getAlarmTime(alarmTime: closestAlarmTime)
      
      timeToWakeUpLabel.text =  "Time to wake UP - \(closestAlarmTimeAsString)"
    }
  }
  
  // MARK: Actions
  @IBAction func doneEditingAlarmRecord(segue:UIStoryboardSegue) {
    if let editAlarmRecordVC = segue.sourceViewController as? EditAlarmTableViewController {
      // Get created or edited alarm record from EditAlarmRecordVC
      workingRecord = editAlarmRecordVC.alarmRecord
      if let dataArray = alarmRecordArray, record = workingRecord {
        // Find which cell containing this record
        if let recordIndex = RecordHelper.getAlarmRecordIndexInAlarmArrays(dataArray, timeStamp: record.timeStamp) {
          // Update Alarm Array
          updateTableViewCell(record, recordIndex: recordIndex)
        } else {
          // Add new Cell
          insertTableViewCell(record)
        }
        // Update TimeToWakeUpLabel
        updateTimeToWakeUpLabel()
      }
    }
  }
  
  private func updateTableViewCell(record: AlarmRecord, recordIndex: Int) {
    // Update Alarm Array
    loadData()
    // Update Cell
    updateTableViewCell(recordIndex, section: 0, tableView: recordsTableView, newAlarmRecord: record, coreDataHelper: cdh)
  }
  
  private func insertTableViewCell(record: AlarmRecord) {
    guard let dataArray = alarmRecordArray else { return }
    
    // Update before add new cell
    loadData()
    // Find which cell containing this record
    if let recordIndex = RecordHelper.getAlarmRecordIndexInAlarmArrays(dataArray, timeStamp: record.timeStamp) {
      recordsTableView.beginUpdates()
      recordsTableView.insertRowsAtIndexPaths([NSIndexPath(forItem: recordIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
      recordsTableView.endUpdates()
    }
  }
  
  // MARK: Deinit
  deinit {
    ThemeObserver.unregister(self)
  }
 }
