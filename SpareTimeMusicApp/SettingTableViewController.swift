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
    private let themeCellLocationInTableView = 0
    private let volumeCellLocationInTableView = 1
    private let developerCellLocationInTableView = 2
    private let donationCellLocationInTableView = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Set state for theme selector cicular views
        setStateForThemeSelectorCircularViews()
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
        setupThemeSelectorCircularView()
        // Setup Volume Slider
        setupVolumeSlider()
        // Add Theme Observer
    }

    // MARK: Setup Volume Slider
    private func setupVolumeSlider() {
        volumeNTSlider.subscribleToUpdateDependOnCurrentTheme()
    }
    
    // MARK: Setup CircularViews
    private func setupThemeSelectorCircularView() {
        // Set Delegate
        blueThemeSelectorCircularView.delegate = self
        orangeThemeSelectorCircularView.delegate = self
        
        // Update Theme
        blueThemeSelectorCircularView.animationDidStopClosure = { [weak self] (onAnimation: Bool, finished: Bool) in
            if let blueThemeSelectorCircularView = self?.blueThemeSelectorCircularView where blueThemeSelectorCircularView.getIsOn() {
                ThemeManager.getSharedInstance().saveTheme(ThemeComponent.ThemeType.Default)
            }
        }
        
        orangeThemeSelectorCircularView.animationDidStopClosure = { [weak self] (onAnimation: Bool, finished: Bool) in
          if let orangeThemeSelectorCircularView = self?.orangeThemeSelectorCircularView where orangeThemeSelectorCircularView.getIsOn() {
            ThemeManager.getSharedInstance().saveTheme(ThemeComponent.ThemeType.Orange)
          }
        }
    }
    
    // CircularViews Delegate
    func circularViewDidTapped(tappedView tappedView: CircularView) {
        switch (tappedView) {
        case blueThemeSelectorCircularView:
            orangeThemeSelectorCircularView.setOn(isOn: blueThemeSelectorCircularView.getIsOn(), isAnimated: true)
        case orangeThemeSelectorCircularView:
            blueThemeSelectorCircularView.setOn(isOn: orangeThemeSelectorCircularView.getIsOn(), isAnimated: true)
        default:
            break
        }
    }
    
    private func setStateForThemeSelectorCircularViews() {
        // Set state for these circular views based on the current theme
        if let currentTheme = ThemeManager.getSharedInstance().currentThemeType {
            switch (currentTheme) {
            case .Default:
                blueThemeSelectorCircularView.setOn(isOn: true, isAnimated: false)
                orangeThemeSelectorCircularView.setOn(isOn: false, isAnimated: false)
            case .Orange:
                blueThemeSelectorCircularView.setOn(isOn: false, isAnimated: false)
                orangeThemeSelectorCircularView.setOn(isOn: true, isAnimated: false)
            }
        }
    }
    
}
