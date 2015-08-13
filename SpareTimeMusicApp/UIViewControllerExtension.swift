//
//  UIViewControllerExtension.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/7/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit


extension UIViewController {

    func setupNavigation() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        self.navigationController!.view.backgroundColor = UIColor.clearColor()

    }
    
    func hideBackButtonTitle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
}

extension UILabel {
    // Fixing AutoLayout bug (http://benguild.com/2014/07/15/fixing-autolayout-uIlabel-ios/)
    public override func layoutSubviews() {
        self.preferredMaxLayoutWidth = self.bounds.size.width
        super.layoutSubviews()
    }
}
