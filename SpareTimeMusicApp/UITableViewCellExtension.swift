//
//  UITableViewCellExtension.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

private protocol NTTableViewCellLayout {
    var topSeparator: UIView { get }
    var separatorColour: UIColor { get }
    func setupCellViews ()
}

extension UITableViewCell: NTTableViewCellLayout {
    private var topSeparator: UIView {
        get {
            let view = UIView(frame: CGRectMake(0, 1.0, self.contentView.frame.size.width, 1))
            view.backgroundColor = self.separatorColour
            return view
        }
    }
    
    private var rightSeparator: UIView {
        get {
            let rightSeperatorPaddingConstant: CGFloat = 0.52
            let rightSeperatorTopPadding = self.contentView.frame.height * (1.0 - rightSeperatorPaddingConstant) / 2.0
            let view = UIView(frame: CGRectMake(self.contentView.frame.size.width - 1, rightSeperatorTopPadding, 1.0, self.contentView.frame.height * rightSeperatorPaddingConstant))
            view.backgroundColor = self.separatorColour
            return view
        }
    }
    
    var separatorColour: UIColor {
        get {
            return UIColor(white: 1, alpha: 0.15)
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Setup Cell's view
        setupCellViews()
    }
    
    func setupCellViews() {
        // Add Separator
        self.topSeparator.removeFromSuperview()
        self.topSeparator.layoutIfNeeded()
        self.addSubview(self.topSeparator)
    }

}