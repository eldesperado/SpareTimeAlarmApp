//
//  NTTimeIntervalPickerView.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/7/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class NTTimeIntervalPickerView: UIControl, UIPickerViewDelegate, UIPickerViewDataSource {

    var timeInterval: NSTimeInterval {
        get {
            let hours = pickerView.selectedRowInComponent(0) * 60
            let minutes = pickerView.selectedRowInComponent(1)
            return NSTimeInterval(hours + minutes)
        }
        set {
            setPickerToTimeInterval(newValue, animated: false)
        }
    }
    
    var timeIntervalAsHousrMinutes:(hours: Int, minutes: Int) {
        get {
            return minutesToHoursMinutes(Int(timeInterval))
        }
    }
    
    func setTimeIntervalAnimate(interval: NSTimeInterval) {
        setPickerToTimeInterval(interval, animated: true)
    }
    
    var textColor: UIColor = UIColor.whiteColor() {
        didSet {
            
        }
    }
    
    // Note that setting a font that makes the picker wider
    // than this view can cause layout problems
    var font = UIFont.systemFontOfSize(24) {
        didSet {
            updateLabels()
            calculateNumberWidth()
            calculateTotalPickerWidth()
            pickerView.reloadAllComponents()
        }
    }

    // MARK: - UI Components
    
    private let pickerView = UIPickerView()
    private let colonLabel = UILabel()
    
    // MARK: - Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Setup
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Setup
        setup()
    }
    
    private func setup() {
        setupLabels()
        calculateNumberWidth()
        calculateTotalPickerWidth()
        setupPickerView()
    }
    
    private func setupLabels() {
        colonLabel.text = ":"
        addSubview(colonLabel)
        updateLabels()
    }
    
    private func updateLabels() {
        colonLabel.font = font
        colonLabel.textColor = textColor
        colonLabel.sizeToFit()
    }
    
    private var numberHeight: CGFloat {
        get {
            let label = UILabel()
            label.font = font
            return label.bounds.height
        }
    }
    
    private func calculateNumberWidth() {
        let label = UILabel()
        label.font = font
        numberWidth = 0
        for i in 0...59 {
            label.text = i < 10 ? "\0(i)" : "\(i)"
            label.sizeToFit()
            if label.frame.width > numberWidth {
                numberWidth = label.frame.width
            }
        }
    }
    
    func calculateTotalPickerWidth() {
        // Used to position labels
        
        totalPickerWidth = 0
        totalPickerWidth += colonLabel.bounds.width
        totalPickerWidth += numberWidth * 2
        totalPickerWidth += standardComponentSpacing * 2
        totalPickerWidth += extraComponentSpacing * 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Reposition labels
        
        colonLabel.center.y = CGRectGetMidY(pickerView.frame)
        let pickerMinX = CGRectGetMidX(pickerView.frame) - extraComponentSpacing + standardComponentSpacing * 2
        colonLabel.frame.origin.x = pickerMinX
    }
    
    func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(pickerView)
        
        // Size picker view to fit self
        let top = NSLayoutConstraint(item: pickerView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1,
            constant: 0)
        
        let bottom = NSLayoutConstraint(item: pickerView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0)
        
        let leading = NSLayoutConstraint(item: pickerView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Leading,
            multiplier: 1,
            constant: 0)
        
        let trailing = NSLayoutConstraint(item: pickerView,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0)
        
        addConstraints([top, bottom, leading, trailing])
    }
    
    // MARK: - Layout
    
    private var totalPickerWidth: CGFloat = 0
    private var numberWidth: CGFloat = 20               // Width of UILabel displaying a two digit number with standard font
    
    private let standardComponentSpacing: CGFloat = 5   // A UIPickerView has a 5 point space between components
    private let extraComponentSpacing: CGFloat = 30     // Add an additional 10 points between the components
    private let rowPadding: CGFloat = 20
    
    
    // MARK: - Picker view data source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch Components(rawValue: component)! {
        case .Hour:
            return 24
        case .Minute:
            return 60
        }
    }
    
    // MARK: - Picker view delegate
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return numberHeight + rowPadding * 2
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return numberWidth + colonLabel.bounds.width + extraComponentSpacing
    }
    
    func pickerView(pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusingView view: UIView!) -> UIView {
            
            // Check if view can be reused
            var newView = view
            
            if newView == nil {
                // Create new view
                let size = pickerView.rowSizeForComponent(component)
                newView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                
                // Setup label and add as subview
                let label = UILabel()
                label.font = font
                label.textColor = self.textColor
                label.textAlignment = .Right
                label.adjustsFontSizeToFitWidth = false
                label.frame.size = CGSize(width: numberWidth, height: size.height)
                newView.addSubview(label)
                
                // Change separator line

            }
            
            let label = newView.subviews.first as! UILabel
            label.text = row < 10 ? "0\(row)" : "\(row)"
            
            return newView
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sendActionsForControlEvents(.ValueChanged)
    }
    
    // MARK: - Helpers
    
    private func setPickerToTimeInterval(interval: NSTimeInterval, animated: Bool) {
        let time = minutesToHoursMinutes(Int(interval))
        pickerView.selectRow(time.hours, inComponent: 0, animated: animated)
        pickerView.selectRow(time.minutes, inComponent: 1, animated: animated)
        self.pickerView(pickerView, didSelectRow: time.hours, inComponent: 0)
        self.pickerView(pickerView, didSelectRow: time.minutes, inComponent: 1)
    }
    
    private func minutesToHoursMinutes(minutes: Int) -> (hours: Int, minutes: Int) {
        return (minutes / 60, minutes % 60)
    }
    
    private enum Components: Int {
        case Hour = 0
        case Minute
    }

}