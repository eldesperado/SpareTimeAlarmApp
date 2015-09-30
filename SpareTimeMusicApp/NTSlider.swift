//
//  NTSlider.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/20/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation


@IBDesignable public class NTSlider: UIControl {

    // MARK: Public Attributes
    @IBInspectable var thumbTintColor: UIColor = UIColor.whiteColor() {
        didSet {
            thumbLayer.fillColor = thumbTintColor.CGColor
        }
    }
    
    @IBInspectable public var trackTintColor: UIColor = UIColor.whiteColor() {
        didSet {
            aboveTrackLayer.backgroundColor = trackTintColor.CGColor
            belowTrackLayer.backgroundColor = trackTintColor.colorWithAlphaComponent(0.5).CGColor
        }
    }
    
    @IBInspectable public var textFont: UIFont = UIFont.systemFontOfSize(14) {
        didSet {
            trackValueLabel.font = textFont
            trackValueLabel.fontSize = textFont.pointSize
            reloadInputViews()
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.whiteColor() {
        didSet {
            trackValueLabel.foregroundColor = textColor.CGColor
            reloadInputViews()
        }
    }
    
    // MARK: Private Attributes
    
    private enum Direction {
        case Left, Right
    }
    
    internal var value: CGFloat = 0.5 {
        didSet {
            thumbLayer.position.x = value * trackLayerWidth
            aboveTrackLayer.frame.size.width = value * bounds.width
        }
    }
    
    private var thumbLayer: CAShapeLayer = CAShapeLayer()
    private var aboveTrackLayer: CALayer = CALayer()
    private var belowTrackLayer: CALayer = CALayer()
    private var trackValueLabel: CATextLayer = CATextLayer()
    private var previousTouchPoint: CGPoint = CGPointZero
    private var numberHeight: CGFloat = 0
    private var numberWidth: CGFloat = 0
    private var componentPadding: CGFloat = 0
    private var trackLayerWidth: CGFloat {
        get {
            return bounds.width
        }
    }
    
    // Constants
    private let trackLayerHeight: CGFloat = 4.0
    private let maxTiltAngle: CGFloat = CGFloat(M_PI / 5)
    
    // MARK: Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Setup
    func setup() {
        // Calculate Label size
        calculateNumberSize()
        // Track Label
        trackValueLabel.frame = CGRectMake(0, 0, numberWidth, numberHeight)
        trackValueLabel.alignmentMode = kCAAlignmentCenter
        trackValueLabel.font = textFont
        trackValueLabel.fontSize = textFont.pointSize
        trackValueLabel.foregroundColor = textColor.CGColor
        trackValueLabel.hidden = true
        layer.addSublayer(trackValueLabel)
        
        let padding: CGFloat = 4.0
        componentPadding = numberHeight + padding
        
        // Below Track Layer
        belowTrackLayer.frame = CGRectMake(0, componentPadding, trackLayerWidth, trackLayerHeight)
        belowTrackLayer.backgroundColor = trackTintColor.colorWithAlphaComponent(0.5).CGColor
        layer.addSublayer(belowTrackLayer)
        // Above Track Layer
        aboveTrackLayer.frame = CGRectMake(0, componentPadding, trackLayerWidth, trackLayerHeight)
        aboveTrackLayer.backgroundColor = trackTintColor.CGColor
        layer.addSublayer(aboveTrackLayer)
        // Thumb Layer
        thumbLayer.frame = CGRectMake(0, componentPadding, 23, 29)
        thumbLayer.path = defaultThumbMaskPath()
        thumbLayer.fillColor = thumbTintColor.CGColor
        thumbLayer.anchorPoint = CGPointMake(0.6, 0)
        thumbLayer.position = CGPointMake(value * trackLayerWidth, trackLayerHeight)
        layer.addSublayer(thumbLayer)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        belowTrackLayer.frame = CGRectMake(0, componentPadding, trackLayerWidth, trackLayerHeight)
        aboveTrackLayer.frame = CGRectMake(0, componentPadding, value * trackLayerWidth, trackLayerHeight)
        thumbLayer.position = CGPointMake(value * trackLayerWidth, componentPadding)
        trackValueLabel.position = CGPointMake(thumbLayer.position.x, trackValueLabel.position.y)
        trackValueLabel.string = "\(Int(value * 100))"
    }

    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousTouchPoint = touch.locationInView(self)
        
        // Show Label
        toggleTrackingLabel(isWantToShow: true)
        
        guard let presentLayer = thumbLayer.presentationLayer() else { return false }
        
        if CGRectContainsPoint(thumbLayer.frame, previousTouchPoint) {
            thumbLayer.transform = presentLayer.transform
            thumbLayer.removeAllAnimations()
            return true
        }
        
        return false
    }
    
    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint = touch.locationInView(self)
        // Calculate Delta
        let deltaX: CGFloat = touchPoint.x - previousTouchPoint.x
        // Update Previous Touch point
        previousTouchPoint = touchPoint
        let tiltAngle: CGFloat = thumbLayer.valueForKeyPath("transform.rotation.z") as! CGFloat
        var currentDirection: Direction = Direction.Right
        var currentMaxTiltAngle = -maxTiltAngle
        
        if deltaX < 0 {
            currentDirection = Direction.Left
            currentMaxTiltAngle = maxTiltAngle
        }
        
        
        // Animation for Text Label
        let labelTransform: CATransform3D = CATransform3DMakeTranslation(deltaX, 0, 0)
        
        
        if !isMaxTilted(direction: currentDirection, angle: tiltAngle) {
            var rotateTransform: CATransform3D = CATransform3DRotate(thumbLayer.transform, deltaX * CGFloat(-M_PI / 180), 0, 0, 1)
            let calculateTiltAngle: CGFloat = atan2(rotateTransform.m12, rotateTransform.m11)
            
            if isMaxTilted(direction: currentDirection, angle: calculateTiltAngle) {
                rotateTransform = CATransform3DRotate(CATransform3DIdentity, currentMaxTiltAngle, 0, 0, 1)
            }
            
            // Begin Animation Transaction
            CATransaction.begin()
            CATransaction.disableActions()
            
            thumbLayer.transform = rotateTransform
            trackValueLabel.transform = labelTransform
            
            CATransaction.commit()
            
        } else {
            // Begin Animation Transaction
            CATransaction.begin()
            CATransaction.disableActions()
            
            let newTrackValue = (thumbLayer.position.x + deltaX) / trackLayerWidth
            value = min(max(newTrackValue, 0.0), 1.0)
            
            trackValueLabel.transform = labelTransform
            CATransaction.commit()
        }
        
        
        return true
    }
    
    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        // Hide Label
        toggleTrackingLabel(isWantToShow: false)
        
        performBackToStablePositionAnimation()
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    override public func cancelTrackingWithEvent(event: UIEvent?) {
        // Hide Label
        toggleTrackingLabel(isWantToShow: false)
        
        performBackToStablePositionAnimation()
    }
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(thumbLayer.frame, point) {
            return true
        }
        
        return super.pointInside(point, withEvent: event)
    }
    
    private func defaultThumbMaskPath() -> CGPath {
        
        //// thumb Drawing
        let thumbPath = UIBezierPath()
        thumbPath.moveToPoint(CGPointMake(14, 10))
        thumbPath.addCurveToPoint(CGPointMake(12.37, 10.12), controlPoint1: CGPointMake(13.45, 10), controlPoint2: CGPointMake(12.9, 10.04))
        thumbPath.addCurveToPoint(CGPointMake(3, 21), controlPoint1: CGPointMake(7.07, 10.91), controlPoint2: CGPointMake(3, 15.48))
        thumbPath.addCurveToPoint(CGPointMake(14, 32), controlPoint1: CGPointMake(3, 27.08), controlPoint2: CGPointMake(7.92, 32))
        thumbPath.addCurveToPoint(CGPointMake(25, 21), controlPoint1: CGPointMake(20.08, 32), controlPoint2: CGPointMake(25, 27.08))
        thumbPath.addCurveToPoint(CGPointMake(14, 10), controlPoint1: CGPointMake(25, 14.92), controlPoint2: CGPointMake(20.08, 10))
        thumbPath.closePath()
        thumbPath.moveToPoint(CGPointMake(14, 3))
        thumbPath.addCurveToPoint(CGPointMake(17.76, 7.51), controlPoint1: CGPointMake(14, 3), controlPoint2: CGPointMake(16.28, 5.73))
        thumbPath.addCurveToPoint(CGPointMake(28, 21), controlPoint1: CGPointMake(23.67, 9.15), controlPoint2: CGPointMake(28, 14.57))
        thumbPath.addCurveToPoint(CGPointMake(14, 35), controlPoint1: CGPointMake(28, 28.73), controlPoint2: CGPointMake(21.73, 35))
        thumbPath.addCurveToPoint(CGPointMake(0, 21), controlPoint1: CGPointMake(6.27, 35), controlPoint2: CGPointMake(-0, 28.73))
        thumbPath.addCurveToPoint(CGPointMake(10.2, 7.52), controlPoint1: CGPointMake(0, 14.58), controlPoint2: CGPointMake(4.32, 9.18))
        thumbPath.addCurveToPoint(CGPointMake(14, 3), controlPoint1: CGPointMake(11.72, 5.73), controlPoint2: CGPointMake(14, 3))
        thumbPath.addLineToPoint(CGPointMake(14, 3))
        thumbPath.closePath()
        
        return thumbPath.CGPath
    }
    
    // MARK: Helpers
    private func isMaxTilted(direction direction: Direction, angle: CGFloat) -> Bool {
        return direction == Direction.Left ? angle >= maxTiltAngle : angle <= -maxTiltAngle
    }
    
    private func performBackToStablePositionAnimation() {
        let animation = SpringAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = thumbLayer.transform.rotationZ();
        animation.toValue = 0;
        thumbLayer.addAnimation(animation, forKey: nil)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        thumbLayer.transform = CATransform3DIdentity
        
        CATransaction.commit()
    }
    
    private func calculateNumberSize() {
        let label = UILabel()
        label.font = textFont
        numberWidth = 0
        numberHeight = 0
        for i in 0...100 {
            label.text = "\(i)"
            label.sizeToFit()
            if label.frame.width > numberWidth {
                numberWidth = label.frame.width
            }
            if label.frame.height > numberHeight {
                numberHeight = label.frame.height
            }
        }
        
    }
    
    private func toggleTrackingLabel(isWantToShow isWantToShow: Bool) {
        UIView.animateWithDuration(0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [weak self] in
            self?.trackValueLabel.hidden = !isWantToShow
            }), completion:nil)
    }
}
