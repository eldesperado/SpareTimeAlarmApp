//
//  FancyTextField.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/13/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

typealias Status = Int

enum StatusType: Status {
    case Active = 1, Inactive = 0
}

typealias TextFieldStatus = (status: StatusType, fontsize: CGFloat, color: UIColor)

@IBDesignable class FancyTextField: NTTextField {
    
    // MARK: Public Properties
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var inactiveFontSize: CGFloat = 14 {
        didSet {
            updateLabels()
            updatePlaceholder()
        }
    }
    
    @IBInspectable var activeFontSize: CGFloat = 22 {
        didSet {
            updateLabels()
            updatePlaceholder()
        }
    }
    
    @IBInspectable var inactiveColor: UIColor = UIColor(white: 1.0, alpha: 0.51) {
        didSet {
            updateLabels()
            updatePlaceholder()
        }
    }
    
    @IBInspectable var activeColor: UIColor = UIColor.whiteColor() {
        didSet {
            updateLabels()
            updatePlaceholder()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            
        }
    }
    
    // MARK: Private Properties
    
    private let placeholderInsets = CGPoint(x: 0, y: 0)
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    
    // MARK: Private Layout Functions
    private func updateLabels() {
        switch (self.isEdit) {
        case true:
            self.font = self.font.fontWithSize(self.activeFontSize)
            self.textColor = self.activeColor
        case false:
            self.font = self.font.fontWithSize(self.inactiveFontSize)
            self.textColor = self.inactiveColor
        default:
            break
        }
    }
    
    private func updatePlaceholder() {
        self.placeholderLabel.text = placeholder
        
        switch (self.isEdit) {
        case true:
            self.placeholderLabel.font = self.font.fontWithSize(self.inactiveFontSize)
            self.placeholderLabel.textColor = self.inactiveColor
        case false:
            self.placeholderLabel.font = self.font.fontWithSize(self.activeFontSize)
            self.placeholderLabel.textColor = self.activeColor
        default:
            break
        }
        self.placeholderLabel.sizeToFit()
    }
    
    // MARK: NTTextFieldProtocol
    override func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: rect.size)
        
        // Set Placeholder
        self.placeholderLabel.frame = frame
        self.placeholderLabel.font = self.font.fontWithSize(self.activeFontSize)
        self.placeholderLabel.textColor = self.activeColor
        addSubview(placeholderLabel)
        
        updatePlaceholder()
        
        // Set Label Text
        self.textColor = self.inactiveColor
        self.font = self.font.fontWithSize(self.inactiveFontSize)
    }
    
    override func animateViewsForTextEntry() {
        // Animate textField placeholder when UITextfield's text is empty
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [unowned self] in
            
            self.updatePlaceholder()
            self.updateLabels()
            
            }), completion: { [unowned self] (completed) in
            })
    }
    
    override func animateViewsForTextDisplay() {
        UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [unowned self] in
            // Animate textField placeholder when UITextfield's text is filled

            self.updatePlaceholder()
            self.updateLabels()
            
            }), completion: { [unowned self] (completed) in
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
