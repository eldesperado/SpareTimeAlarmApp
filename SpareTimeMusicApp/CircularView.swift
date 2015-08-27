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
    var isPressed: Bool = false
    var animationDidStartClosure = {(onAnimation: Bool) -> Void in }
    var animationDidStopClosure = {(onAnimation: Bool, finished: Bool) -> Void in }
    
    // MARK: Private Attributes
    private var innerLayer: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!
    private var initialInnerLayerPath: CGPath!
    private var initialBackgroundLayerPath: CGPath!
    
    // MARK: Public Methods
    func setOn(isOn: Bool) {
        self.isPressed = isOn
        shapeTouched()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundLayer()
        setBackgroundInnerLayer()
        setUserInteraction()
    }
    
    private func setBackgroundLayer() {
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundLayer.path = path.CGPath
            backgroundLayer.lineWidth = lineWidth
            backgroundLayer.fillColor = backgroundLayerColor.CGColor
            self.initialBackgroundLayerPath = path.CGPath
        }
        
        backgroundLayer.frame = layer.bounds
    }

    private func setBackgroundInnerLayer() {
        // Set Background image
        if innerLayer == nil {
            innerLayer = CAShapeLayer()
            let dx = lineWidth + 3.0
            let path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, dx, dx))
            innerLayer.fillColor = self.innerColor.CGColor
            innerLayer.path = path.CGPath
            innerLayer.frame = self.bounds
            layer.addSublayer(innerLayer)
            // Stored Initial Inner Layer's Path
            self.initialInnerLayerPath = path.CGPath
        }
        
    }
    private func setUserInteraction() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "circularViewDidTapped")
        self.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func circularViewDidTapped() {
        shapeTouched()
    }
    
    private func shapeTouched() {
        let scaleUpAnimationKey = "scaleUp"
        let scaleDownAnimationKey = "scaleDown"
        if !self.isPressed {
            CATransaction.begin()

            // Add ScaleUp Animation
            var scaleUpAnimation: CABasicAnimation = animateKeyPath("path", fromValue: nil, toValue: self.initialBackgroundLayerPath, timing: kCAMediaTimingFunctionEaseOut)
            
            self.innerLayer.addAnimation(scaleUpAnimation, forKey: scaleUpAnimationKey)
            
            CATransaction.commit()
        } else {
            CATransaction.begin()

            // Add ScaleDown Animation
            let scaleDownAnimation: CABasicAnimation = animateKeyPath("path", fromValue: nil, toValue: self.initialInnerLayerPath, timing: kCAMediaTimingFunctionEaseOut)
            self.innerLayer.addAnimation(scaleDownAnimation, forKey: scaleDownAnimationKey)
            
            CATransaction.commit()
        }
        // Change state
        self.isPressed = !self.isPressed
    }
    
    //CAAnimation delegate
    
    
    override func animationDidStart(anim: CAAnimation!){
        animationDidStartClosure(isPressed)
    }
    
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool){
        animationDidStopClosure(isPressed, flag)
    }
    
    // MARK: Helpers
    private func animateKeyPath(keyPath: String, fromValue from: AnyObject?, toValue to: AnyObject, timing timingFunction: String) -> CABasicAnimation {
        
        let animation:CABasicAnimation = CABasicAnimation(keyPath: keyPath)
        if let fromVal: AnyObject = from {
            animation.fromValue = fromVal
        }
        animation.toValue = to
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = 0.3
        animation.delegate = self
        
        return animation
    }
}
