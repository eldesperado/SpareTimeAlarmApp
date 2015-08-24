//
//  CircularImageView.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/19/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

@IBDesignable class CircularView: UIView {

    // MARK: Public Attributes
    @IBInspectable var backgroundLayerColor: UIColor = UIColor.whiteColor()
    @IBInspectable var lineWidth: CGFloat = 1.0
    @IBInspectable var innerColor: UIColor = UIColor.blackColor()
    // MARK: Private Attributes
    private var innerLayer: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundLayer()
        setBackgroundInnerLayer()
    }
    
    func setBackgroundLayer() {
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundLayer.path = path.CGPath
            backgroundLayer.lineWidth = lineWidth
            backgroundLayer.fillColor = backgroundLayerColor.CGColor
        }
        
        backgroundLayer.frame = layer.bounds
    }

    func setBackgroundInnerLayer() {
        // Set Background image
        if innerLayer == nil {
            let innerLayer = CAShapeLayer()
            let dx = lineWidth + 3.0
            let path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, dx, dx))
            innerLayer.fillColor = self.innerColor.CGColor
            innerLayer.path = path.CGPath
            innerLayer.frame = self.bounds
            layer.addSublayer(innerLayer)
        }
        
    }
}
