//
//  NTTextField.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/13/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class NTTextField: UITextField {
  
  internal typealias Status = Int
  
  internal enum StatusType: Status {
    case Active = 1, Inactive = 0
    var boolValue: Bool {
      get {
        switch (self) {
        case .Active:
          return true
        case .Inactive:
          return false
        }
      }
    }
  }
  
  internal typealias TextFieldStatus = (status: StatusType, fontsize: CGFloat, color: UIColor)
  
  let placeholderLabel = UILabel()
  internal var isEdit: StatusType = StatusType.Inactive
  
  var actionWhenTextFieldDidBeginEditing: (() -> Void)?
  var actionWhenTextFieldDidEndEditing: (() -> Void)?
  
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
    isEdit = StatusType.Active
    animateViewsForTextEntry()
    // Perform action if has
    if let action = actionWhenTextFieldDidBeginEditing {
      action()
    }
  }
  
  func textFieldDidEndEditing() {
    isEdit = StatusType.Inactive
    animateViewsForTextDisplay()
    // Perform action if has
    if let action = actionWhenTextFieldDidEndEditing {
      action()
    }
  }
}
