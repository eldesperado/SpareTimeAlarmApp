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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let unwindSegueId = "doneRepeatDatesSelectionUnwindSegue"
    override func viewWillDisappear(animated: Bool) {
        // Detect whether back button is pressed or not, if pressed, perform unwind segue
        if (find(self.navigationController!.viewControllers as! [UIViewController], self) == nil) {
            // back button was pressed.  We know this is true because self is no longer
            // in the navigation stack.
            self.performSegueWithIdentifier(unwindSegueId, sender: self)
        }
        super.viewWillDisappear(animated)
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
        if let date = self.repeatDates {
            switch (indexPath.row) {
            case NumberToDate.Monday.rawValue:
                date.isMon = !date.isMon.boolValue
            case NumberToDate.Tuesday.rawValue:
                date.isTue = !date.isTue.boolValue
            case NumberToDate.Wednesday.rawValue:
                date.isWed = !date.isWed.boolValue
            case NumberToDate.Thursday.rawValue:
                date.isThu = !date.isThu.boolValue
            case NumberToDate.Friday.rawValue:
                date.isFri = !date.isFri.boolValue
            case NumberToDate.Saturday.rawValue:
                date.isSat = !date.isSat.boolValue
            case NumberToDate.Sunday.rawValue:
                date.isSun = !date.isSun.boolValue
            default:
                break
            }
        }
    }
    
    // MARK: Navigation Configuration
    func configureNavigation() {

    }
}
