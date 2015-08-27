//
//  SettingTableViewController.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/17/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {


    @IBOutlet weak var blueThemeSelectorCircularView: CircularView!
    @IBOutlet weak var orangeThemeSelectorCircularView: CircularView!
    // Private constant
    private let THEME_CELL: Int = 0
    private let VOLUME_CELL: Int = 1
    private let DEVELOPER_CELL: Int = 2
    private let DONATION_CELL: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup CircularViews
        setupThemeSelectorCircularView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    // MARK: Setup CircularViews
    private func setupThemeSelectorCircularView() {
//        self.blueThemeSelectorCircularView.animationDidStartClosure = {(onAnimation: Bool) in
//            self.orangeThemeSelectorCircularView.setOn(self.blueThemeSelectorCircularView.isPressed)
//        }
        self.blueThemeSelectorCircularView.animationDidStopClosure  = {[unowned self] (onAnimation: Bool, finished: Bool) in
            if self.blueThemeSelectorCircularView.isPressed {
                ThemeManager.sharedInstance.saveTheme(ThemeManager.ThemeType.Default)
            }
        }
//        self.orangeThemeSelectorCircularView.animationDidStartClosure = {(onAnimation: Bool) in
//            self.blueThemeSelectorCircularView.setOn(self.orangeThemeSelectorCircularView.isPressed)
//        }
        self.orangeThemeSelectorCircularView.animationDidStopClosure  = {[unowned self] (onAnimation: Bool, finished: Bool) in
            if self.orangeThemeSelectorCircularView.isPressed {
                ThemeManager.sharedInstance.saveTheme(ThemeManager.ThemeType.Orange)
            }
        }

    }
    

}
