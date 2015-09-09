//
//  NTTimeIntervalPickerView.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/7/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

@IBDesignable class NTTimeIntervalPickerView: UIControl, UIPickerViewDelegate, UIPickerViewDataSource {

    var timeInterval: NSTimeInterval {
        get {
            let hours = pickerView.selectedRowInComponent(0) * 60
            let minutes = pickerView.selectedRowInComponent(1)
            return NSTimeInterval(hours + minutes)
        }
        set {
            self.setPickerToTimeInterval(newValue, animated: false)
        }
    }
    
    var timeIntervalAsHousrMinutes:(hours: Int, minutes: Int) {
        get {
            return self.minutesToHoursMinutes(Int(timeInterval))
        }
    }
    
    func setTimeIntervalAnimate(interval: NSTimeInterval) {
        self.setPickerToTimeInterval(interval, animated: true)
    }
    
    @IBInspectable var textColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.updateLabels()
            pickerView.reloadAllComponents()
        }
    }
    
    // Note that setting a font that makes the picker wider
    // than this view can cause layout problems
    @IBInspectable var textFont: UIFont = UIFont.systemFontOfSize(24) {
        didSet {
            self.updateLabels()
            self.calculateNumberSize()
            self.calculateTotalPickerWidth()
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
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Setup
        self.setup()
    }
    
    private func setup() {
        self.setupLabels()
        self.calculateNumberSize()
        self.calculateTotalPickerWidth()
        self.setupPickerView()
    }
    
    private func setupLabels() {
        colonLabel.text = ":"
        self.addSubview(colonLabel)
        self.updateLabels()
    }
    
    private func updateLabels() {
        colonLabel.font = textFont
        colonLabel.textColor = textColor
        colonLabel.sizeToFit()
    }
    
    private func calculateNumberSize() {
        let label = UILabel()
        label.font = textFont
        numberWidth = 0
        for i in 0...59 {
            label.text = i < 10 ? "\0(i)" : "\(i)"
            label.sizeToFit()
            if label.frame.width > numberWidth {
                numberWidth = label.frame.width
            }
            if label.frame.height > numberHeight {
                numberHeight = label.frame.height
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
        let pickerMinX = CGRectGetMidX(pickerView.frame)
        colonLabel.frame.origin.x = pickerMinX - colonLabel.bounds.width / 2
    }
    
    func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(pickerView)
        
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
        
        self.addConstraints([top, bottom, leading, trailing])
    }
    
    // MARK: - Layout
    
    private var totalPickerWidth: CGFloat = 0
    private var numberWidth: CGFloat = 20               // Width of UILabel displaying a two digit number with standard font
    private var numberHeight: CGFloat = 0               // Height of UILabel displaying a two digit number with standard font
    
    private let standardComponentSpacing: CGFloat = 5   // A UIPickerView has a 5 point space between components
    private let extraComponentSpacing: CGFloat = 30     // Add an additional 10 points between the components
    private let labelSpacing: CGFloat = 5               // Spacing between picker numbers and labels
    
    
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
        return numberHeight * 1.5
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return numberWidth + labelSpacing * 2 + extraComponentSpacing
    }
    
    func pickerView(pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusingView view: UIView!) -> UIView {
            
            // Check if view can be reused
            var newView = view
            switch Components(rawValue: component)! {
            case .Hour:
                if newView == nil {
                    // Create new view
                    let size = pickerView.rowSizeForComponent(component)
                    newView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    
                    // Setup label and add as subview
                    let label = UILabel()
                    label.font = textFont
                    label.textColor = self.textColor
                    label.textAlignment = .Right
                    label.adjustsFontSizeToFitWidth = false
                    label.frame = CGRectMake(0, 0, numberWidth, size.height)
                    newView.addSubview(label)
                }
                
                let label = newView.subviews.first as! UILabel
                label.text = row < 10 ? "0\(row)" : "\(row)"
                
                return newView
            case .Minute:
                if newView == nil {
                    // Create new view
                    let size = pickerView.rowSizeForComponent(component)
                    newView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    
                    // Setup label and add as subview
                    let label = UILabel()
                    label.font = textFont
                    label.textColor = self.textColor
                    label.textAlignment = .Right
                    label.adjustsFontSizeToFitWidth = false
                    label.frame = CGRectMake(size.width / 2, CGFloat(0), numberWidth, size.height)
                    newView.addSubview(label)
                    
                }
                
                let label = newView.subviews.first as! UILabel
                label.text = row < 10 ? "0\(row)" : "\(row)"
                
                // Hide Separator Lines (http://stackoverflow.com/questions/20612279/ios7-uipickerview-how-to-hide-the-selection-indicator)
                if let upperSeparatorView = pickerView.subviews[1] as? UIView {
                    upperSeparatorView.hidden = true
                }
                
                if let belowSeparatorView = pickerView.subviews[2] as? UIView {
                    belowSeparatorView.hidden = true
                }
                
                return newView
            }
            
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sendActionsForControlEvents(.ValueChanged)
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
