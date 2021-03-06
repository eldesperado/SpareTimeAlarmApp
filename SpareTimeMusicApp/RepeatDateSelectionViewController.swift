//
//  RepeatDateSelectionViewController.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class RepeatDateSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let numberOfDates = 7
  var repeatDates: RepeatDate?
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  let unwindSegueId = "doneRepeatDatesSelectionUnwindSegue"
  override func viewWillDisappear(animated: Bool) {
    // Detect whether back button is pressed or not, if pressed, perform unwind segue
    if ((navigationController!.viewControllers ).indexOf(self) == nil) {
      // back button was pressed.  We know this is true because self is no longer
      // in the navigation stack.
      performSegueWithIdentifier(unwindSegueId, sender: repeatDates)
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
    return numberOfDates
  }
  
  let cellIdentifier = "repeatDateCell"
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: RepeatDateSelectionTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RepeatDateSelectionTableViewCell
    // If RepeatDate has info, edit repeat dates
    let dateNumber = indexPath.row + 1
    cell.configureCell(dateNumber, repeatDate: repeatDates)
    
    return cell
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell: RepeatDateSelectionTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! RepeatDateSelectionTableViewCell
    cell.checkIconImageView.hidden = !cell.checkIconImageView.hidden
    if let date = repeatDates {
      let dateNumber = indexPath.row + 1
      switch (dateNumber) {
      case NumberToDate.Monday.date:
        date.isMon = !date.isMon.boolValue
      case NumberToDate.Tuesday.date:
        date.isTue = !date.isTue.boolValue
      case NumberToDate.Wednesday.date:
        date.isWed = !date.isWed.boolValue
      case NumberToDate.Thursday.date:
        date.isThu = !date.isThu.boolValue
      case NumberToDate.Friday.date:
        date.isFri = !date.isFri.boolValue
      case NumberToDate.Saturday.date:
        date.isSat = !date.isSat.boolValue
      case NumberToDate.Sunday.date:
        date.isSun = !date.isSun.boolValue
      default:
        break
      }
    }
  }
  
  // MARK: Setup Views
  private func setupView() {
    if let component = ThemeManager.getSharedInstance().getThemeComponent(ThemeComponent.ThemeAttribute.BackgroundImage) as? UIImage {
      backgroundImageView.image = component
    }
    
    observeTheme()
  }
  
  private func observeTheme() {
    ThemeObserver.onMainThread(self) { [weak self] notification in
      // Set theme
      if let component = ThemeManager.getSharedInstance().getThemeComponent(ThemeComponent.ThemeAttribute.BackgroundImage) as? UIImage {
        self?.backgroundImageView.image = component
        // Animate Change
        self?.backgroundImageView.layer.animateThemeChangeAnimation()
      }
    }
  }
  
  // MARK: Navigation Configuration
  func configureNavigation() {
    
  }
  
  // MARK: Deinit
  deinit {
    ThemeObserver.unregister(self)
  }
}
