//
//  UITableViewCellExtension.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

extension UITableViewCell {
  // MARK: Private Attributes
  private var topSeparator: UIView {
    get {
      let view = UIView(frame: CGRectMake(0, 1.0, frame.size.width, 1))
      view.backgroundColor = separatorColour
      return view
    }
  }
  
  private var rightSeparator: UIView {
    get {
      let rightSeperatorPaddingConstant: CGFloat = 0.52
      let rightSeperatorTopPadding = frame.height * (1.0 - rightSeperatorPaddingConstant) / 2.0
      let view = UIView(frame: CGRectMake(frame.size.width - 1, rightSeperatorTopPadding, 1.0, frame.height * rightSeperatorPaddingConstant))
      view.backgroundColor = separatorColour
      return view
    }
  }
  
  var separatorColour: UIColor {
    get {
      return UIColor(white: 1, alpha: 0.15)
    }
  }
  
  // MARK: Override Methods
  
  override public func awakeFromNib() {
    super.awakeFromNib()
  }
  public override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    setupCellViews()
  }
  
  
  // MARK: Setup Default TableViewCells
  func setupCellViews() {
    // Add Separator
    topSeparator.removeFromSuperview()
    topSeparator.layoutIfNeeded()
    addSubview(topSeparator)
  }
  
}