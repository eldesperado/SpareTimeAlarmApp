//
//  NTTextField.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/13/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

protocol NTTextFieldProtocol {
    func drawViewsForRect(rect: CGRect)
    func updateViewsForBoundsChange(bounds: CGRect)
    func animateViewsForTextEntry()
    func animateViewsForTextDisplay()
}

class NTTextField: UITextField, NTTextFieldProtocol {

    let placeholderLabel = UILabel()
    var isEdit: Bool = false
    
    func animateViewsForTextEntry() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    func animateViewsForTextDisplay() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    func drawViewsForRect(rect: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    func updateViewsForBoundsChange(bounds: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    override func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    // MARK: Override
    override func drawRect(rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    // MARK: - UITextField Observing
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        if newSuperview != nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidEndEditing", name:UITextFieldTextDidEndEditingNotification, object: self)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidBeginEditing", name:UITextFieldTextDidBeginEditingNotification, object: self)
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    func textFieldDidBeginEditing() {
        self.isEdit = true
        animateViewsForTextEntry()
    }
    
    func textFieldDidEndEditing() {
        self.isEdit = false
        animateViewsForTextDisplay()
    }
}