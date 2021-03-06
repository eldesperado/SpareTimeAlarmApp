//
//  NTTableViewController.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/12/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit


extension UIViewController {
  // MARK: TableView's Action
  // Update TableViewCell
  func updateTableViewCell(indexOfCell: Int, section: Int, tableView: UITableView, newAlarmRecord: AlarmRecord, coreDataHelper: CoreDataHelper) {
    let record = coreDataHelper.findRecord(newAlarmRecord.objectID, managedObjectContext: coreDataHelper.managedObjectContext!) as! AlarmRecord
    // Update Record
    record.copyValueFrom(newAlarmRecord)
    tableView.beginUpdates()
    // Update TableViewCell
    tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexOfCell, inSection: section)], withRowAnimation: UITableViewRowAnimation.Fade)
    tableView.endUpdates()
  }
}
