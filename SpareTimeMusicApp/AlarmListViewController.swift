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
    
    var timer = NSTimer()
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
        }()
    
    var alarmRecordArray: [AlarmRecord]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        // Add Demo Data
//        self.cdh.insertAlarmRecord(845, ringtoneType: 0, isRepeat: true, repeatDate: nil)
        // Load Data
        self.alarmRecordArray = self.cdh.listAllActiveAlarmRecordsMostRecently()
        // Display Clock
        updateClock()
        // Hide footer
        self.recordsTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func updateClock() {
        self.clockView.setNeedsDisplay()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateClock"), userInfo: nil, repeats: false)
    }
    
    // pragmark: UITableViewDelegates
    
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
        cell.configureCell(alarmRecord: record)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let setting = UITableViewRowAction(style: .Normal, title: "Setting") { (action, index) -> Void in
            //
        }
        setting.backgroundColor = UIColor.clearColor()
        let remove = UITableViewRowAction(style: .Normal, title: "Remove") { (action, index) -> Void in
            //
        }
        remove.backgroundColor = UIColor.clearColor()
        return [setting, remove]
    }
    
}
