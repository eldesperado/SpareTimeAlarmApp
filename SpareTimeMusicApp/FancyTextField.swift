//
//  FancyTextField.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/13/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

@IBDesignable class FancyTextField: NTTextField {
    
    // MARK: Public Properties
    override var placeholder: String? {
        didSet {
            self.update()
        }
    }
    
    @IBInspectable var inactiveFontSize: CGFloat = 14 {
        didSet {
            self.update()
        }
    }
    
    @IBInspectable var activeFontSize: CGFloat = 22 {
        didSet {
            self.update()
        }
    }
    
    @IBInspectable var inactiveColor: UIColor = UIColor(white: 1.0, alpha: 0.51) {
        didSet {
            self.update()
        }
    }
    
    @IBInspectable var activeColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.update()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            self.update()
        }
    }
    
    // MARK: Private Properties
    
    private let placeholderInsets = CGPoint(x: 0, y: 0)
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    private var inactiveTextFieldStatus = (status: StatusType.Inactive, fontsize: CGFloat(0.0), color: UIColor.whiteColor())
    private var activeTextFieldStatus = (StatusType.Active, fontsize: CGFloat(0.0), color: UIColor.whiteColor())
    
    // MARK: Private Layout Functions
    private func updateLabels(status: TextFieldStatus) {

        if let aFont = self.font {
            self.font = aFont.fontWithSize(status.fontsize)
        }
        self.textColor = status.color
    }
    
    private func updatePlaceholder(status: TextFieldStatus) {
        self.placeholderLabel.text = placeholder
        if let aFont = self.font {
            self.font = aFont.fontWithSize(status.fontsize)
        }
        self.placeholderLabel.textColor = status.color
        self.placeholderLabel.sizeToFit()
    }
    
    private func update() {
        self.inactiveTextFieldStatus.color = self.inactiveColor
        self.inactiveTextFieldStatus.fontsize = self.inactiveFontSize
        self.activeTextFieldStatus.color = self.activeColor
        self.activeTextFieldStatus.fontsize = self.activeFontSize
        // Update Label & placeholder
        switch (self.isEdit) {
        case .Active:
            self.updateLabels(activeTextFieldStatus)
            self.updatePlaceholder(inactiveTextFieldStatus)
        case .Inactive:
            self.updateLabels(inactiveTextFieldStatus)
            self.updatePlaceholder(activeTextFieldStatus)
        }
        self.reloadInputViews()
    }
    
    // MARK: NTTextFieldProtocol
    override func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: rect.size)
        
        // Set Placeholder
        self.placeholderLabel.frame = frame
        if let aFont = self.font {
            self.font = aFont.fontWithSize(self.activeFontSize)
        }
        self.placeholderLabel.textColor = self.activeColor
        self.addSubview(placeholderLabel)
        
        // Update
        self.update()
        
        // Set Label Text
        self.textColor = self.inactiveColor
        if let aFont = self.font {
            self.font = aFont.fontWithSize(self.inactiveFontSize)
        }
    }
    
    override func animateViewsForTextEntry() {
        // Animate textField placeholder when UITextfield's text is empty
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [unowned self] in
            
            self.update()
            
            }), completion: { (completed) in
            })
    }
    
    override func animateViewsForTextDisplay() {
        UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [unowned self] in
            // Animate textField placeholder when UITextfield's text is filled

            self.update()
            
            }), completion: { (completed) in
        })
        
    }
    
    // MARK: Overrides
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
}
