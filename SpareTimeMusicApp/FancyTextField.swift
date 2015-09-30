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
      update()
    }
  }
  
  @IBInspectable var inactiveFontSize: CGFloat = 14 {
    didSet {
      update()
    }
  }
  
  @IBInspectable var activeFontSize: CGFloat = 22 {
    didSet {
      update()
    }
  }
  
  @IBInspectable var inactiveColor: UIColor = UIColor(white: 1.0, alpha: 0.51) {
    didSet {
      update()
    }
  }
  
  @IBInspectable var activeColor: UIColor = UIColor.whiteColor() {
    didSet {
      update()
    }
  }
  
  override var bounds: CGRect {
    didSet {
      update()
    }
  }
  
  // MARK: Private Properties
  
  private let placeholderInsets = CGPoint(x: 0, y: 0)
  private let textFieldInsets = CGPoint(x: 0, y: 12)
  private var inactiveTextFieldStatus = (status: StatusType.Inactive, fontsize: CGFloat(0.0), color: UIColor.whiteColor())
  private var activeTextFieldStatus = (StatusType.Active, fontsize: CGFloat(0.0), color: UIColor.whiteColor())
  
  // MARK: Private Layout Functions
  private func updateLabels(status: TextFieldStatus) {
    
    if let aFont = font {
      font = aFont.fontWithSize(status.fontsize)
    }
    textColor = status.color
  }
  
  private func updatePlaceholder(status: TextFieldStatus) {
    placeholderLabel.text = placeholder
    if let aFont = font {
      font = aFont.fontWithSize(status.fontsize)
    }
    placeholderLabel.textColor = status.color
    placeholderLabel.sizeToFit()
  }
  
  private func update() {
    inactiveTextFieldStatus.color = inactiveColor
    inactiveTextFieldStatus.fontsize = inactiveFontSize
    activeTextFieldStatus.color = activeColor
    activeTextFieldStatus.fontsize = activeFontSize
    // Update Label & placeholder
    switch (isEdit) {
    case .Active:
      updateLabels(activeTextFieldStatus)
      updatePlaceholder(inactiveTextFieldStatus)
    case .Inactive:
      updateLabels(inactiveTextFieldStatus)
      updatePlaceholder(activeTextFieldStatus)
    }
    reloadInputViews()
  }
  
  // MARK: NTTextFieldProtocol
  override func drawViewsForRect(rect: CGRect) {
    let frame = CGRect(origin: CGPointZero, size: rect.size)
    
    // Set Placeholder
    placeholderLabel.frame = frame
    if let aFont = font {
      font = aFont.fontWithSize(activeFontSize)
    }
    placeholderLabel.textColor = activeColor
    addSubview(placeholderLabel)
    
    // Update
    update()
    
    // Set Label Text
    textColor = inactiveColor
    if let aFont = font {
      font = aFont.fontWithSize(inactiveFontSize)
    }
  }
  
  override func animateViewsForTextEntry() {
    // Animate textField placeholder when UITextfield's text is empty
    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [weak self] in
      
      self?.update()
      
      }), completion: { (completed) in
    })
  }
  
  override func animateViewsForTextDisplay() {
    UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [weak self] in
      // Animate textField placeholder when UITextfield's text is filled
      
      self?.update()
      
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
