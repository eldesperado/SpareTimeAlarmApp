//
//  CircularImageView.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/19/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

protocol CircularViewDelegate {
  func circularViewDidTapped(tappedView tappedView: CircularView)
}

@IBDesignable class CircularView: UIView {
  
  // MARK: Public Attributes
  @IBInspectable var backgroundLayerColor: UIColor = UIColor.whiteColor() {
    didSet {
      backgroundLayer.fillColor = backgroundLayerColor.CGColor
    }
  }
  @IBInspectable var lineWidth: CGFloat = 1.0 {
    didSet {
      backgroundLayer.lineWidth = lineWidth
    }
  }
  @IBInspectable var innerColor: UIColor = UIColor.blackColor() {
    didSet {
      innerLayer.fillColor = innerColor.CGColor
    }
  }
  
  var animationDidStartClosure = {(onAnimation: Bool) -> Void in }
  var animationDidStopClosure = {(onAnimation: Bool, finished: Bool) -> Void in }
  var delegate: CircularViewDelegate?
  
  // MARK: Private Attributes
  private var isOn: Bool = false
  private var innerLayer: CAShapeLayer!
  private var backgroundLayer: CAShapeLayer!
  private var initialInnerLayerPath: CGPath!
  private var initialBackgroundLayerPath: CGPath!
  
  // MARK: Public Methods
  func setOn(isOn isOn: Bool, isAnimated: Bool) {
    self.isOn = isOn
    shapeTouched(isAnimated: isAnimated)
  }
  
  func getIsOn() -> Bool {
    return isOn
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  private func setup() {
    setBackgroundLayer()
    setBackgroundInnerLayer()
    setUserInteraction()
    isOn = false
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
      initialBackgroundLayerPath = path.CGPath
    }
    
    backgroundLayer.frame = layer.bounds
  }
  
  private func setBackgroundInnerLayer() {
    // Set Background image
    if innerLayer == nil {
      innerLayer = CAShapeLayer()
      let dx = lineWidth + 3.0
      let path = UIBezierPath(ovalInRect: CGRectInset(bounds, dx, dx))
      innerLayer.fillColor = innerColor.CGColor
      innerLayer.path = path.CGPath
      innerLayer.frame = bounds
      layer.addSublayer(innerLayer)
      // Stored Initial Inner Layer's Path
      initialInnerLayerPath = path.CGPath
    }
    
  }
  private func setUserInteraction() {
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "circularViewDidTapped")
    addGestureRecognizer(tapGesture)
  }
  
  @IBAction func circularViewDidTapped() {
    if let delegate = delegate {
      delegate.circularViewDidTapped(tappedView: self)
    }
    // Change state
    isOn = !isOn
    shapeTouched(isAnimated: true)
  }
  
  private func shapeTouched(isAnimated isAnimated: Bool) {
    let scaleUpAnimationKey = "scaleUp"
    let scaleDownAnimationKey = "scaleDown"
    if isOn {
      if (isAnimated) {
        CATransaction.begin()
        
        // Add ScaleDown Animation
        let scaleDownAnimation: CABasicAnimation = animateKeyPath("path", fromValue: nil, toValue: initialInnerLayerPath, timing: kCAMediaTimingFunctionEaseOut)
        innerLayer.addAnimation(scaleDownAnimation, forKey: scaleDownAnimationKey)
        
        CATransaction.commit()
      } else {
        innerLayer.path = initialInnerLayerPath
      }
    } else {
      if (isAnimated) {
        CATransaction.begin()
        
        // Add ScaleUp Animation
        let scaleUpAnimation: CABasicAnimation = animateKeyPath("path", fromValue: nil, toValue: initialBackgroundLayerPath, timing: kCAMediaTimingFunctionEaseOut)
        
        innerLayer.addAnimation(scaleUpAnimation, forKey: scaleUpAnimationKey)
        
        CATransaction.commit()
      } else {
        innerLayer.path = initialBackgroundLayerPath
      }
      
    }
  }
  
  // CAAnimation delegate
  override func animationDidStart(anim: CAAnimation){
    // Do DidStartClosure
    animationDidStartClosure(isOn)
  }
  
  
  override func animationDidStop(anim: CAAnimation, finished flag: Bool){
    // Do DidStopClosure
    animationDidStopClosure(isOn, flag)
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
