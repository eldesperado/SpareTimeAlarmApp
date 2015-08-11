//
//  RepeatDateSelectionViewController.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class RepeatDateSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let numberOfDates: Int = 7
    var repeatDates: RepeatDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfDates
    }
    
    let cellIdentifier = "repeatDateCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RepeatDateSelectionTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RepeatDateSelectionTableViewCell
        // If RepeatDate has info, edit repeat dates
        cell.configureCell(indexPath.row, repeatDate: self.repeatDates)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: RepeatDateSelectionTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! RepeatDateSelectionTableViewCell
        cell.checkIconImageView.hidden = !cell.checkIconImageView.hidden
    }    
}
