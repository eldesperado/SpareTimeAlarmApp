//
//  SettingTableViewController.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/17/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController, CircularViewDelegate {

    @IBOutlet weak var blueThemeSelectorCircularView: CircularView!
    @IBOutlet weak var orangeThemeSelectorCircularView: CircularView!
    @IBOutlet weak var volumeNTSlider: NTSlider!
    // Private constant
    private let THEME_CELL: Int = 0
    private let VOLUME_CELL: Int = 1
    private let DEVELOPER_CELL: Int = 2
    private let DONATION_CELL: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        self.setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Set state for theme selector cicular views
        self.setStateForThemeSelectorCircularViews()
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
    
    // MARK: Setup
    private func setup() {
        // Setup CircularViews
        self.setupThemeSelectorCircularView()
        // Setup Volume Slider
        self.setupVolumeSlider()
        // Add Theme Observer
    }

    // MARK: Setup Volume Slider
    private func setupVolumeSlider() {
        self.volumeNTSlider.subscribleToUpdateDependOnCurrentTheme()
    }
    
    // MARK: Setup CircularViews
    private func setupThemeSelectorCircularView() {
        // Set Delegate
        self.blueThemeSelectorCircularView.delegate = self
        self.orangeThemeSelectorCircularView.delegate = self
        
        // Update Theme
        self.blueThemeSelectorCircularView.animationDidStopClosure = { (onAnimation: Bool, finished: Bool) in
            if self.blueThemeSelectorCircularView.getIsOn() {
                ThemeManager.sharedInstance.saveTheme(ThemeComponent.ThemeType.Default)
            }
        }
        
        self.orangeThemeSelectorCircularView.animationDidStopClosure = { (onAnimation: Bool, finished: Bool) in
            if self.orangeThemeSelectorCircularView.getIsOn() {
                ThemeManager.sharedInstance.saveTheme(ThemeComponent.ThemeType.Orange)
            }
        }
    }
    
    // CircularViews Delegate
    func circularViewDidTapped(#tappedView: CircularView) {
        switch (tappedView) {
        case self.blueThemeSelectorCircularView:
            self.orangeThemeSelectorCircularView.setOn(isOn: self.blueThemeSelectorCircularView.getIsOn(), isAnimated: true)
        case self.orangeThemeSelectorCircularView:
            self.blueThemeSelectorCircularView.setOn(isOn: self.orangeThemeSelectorCircularView.getIsOn(), isAnimated: true)
        default:
            break
        }
    }
    
    private func setStateForThemeSelectorCircularViews() {
        // Set state for these circular views based on the current theme
        if let currentTheme = ThemeManager.sharedInstance.currentThemeType {
            switch (currentTheme) {
            case .Default:
                self.blueThemeSelectorCircularView.setOn(isOn: true, isAnimated: false)
                self.orangeThemeSelectorCircularView.setOn(isOn: false, isAnimated: false)
            case .Orange:
                self.blueThemeSelectorCircularView.setOn(isOn: false, isAnimated: false)
                self.orangeThemeSelectorCircularView.setOn(isOn: true, isAnimated: false)
            }
        }
    }
    
}
