//
//  SevenSwitch.swift
//
//  Created by Benjamin Vogelzang on 6/20/14.
//  Copyright (c) 2014 Ben Vogelzang. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import QuartzCore

@IBDesignable @objc public class SevenSwitch: UIControl {
  
  // public
  
  /*
  *   Set (without animation) whether the switch is on or off
  */
  @IBInspectable public var on: Bool {
    get {
      return switchValue
    }
    set {
      switchValue = newValue
      setOn(newValue, animated: false)
    }
  }
  
  /*
  *	Sets the background color that shows when the switch off and actively being touched.
  *   Defaults to light gray.
  */
  @IBInspectable public var activeColor: UIColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1) {
    willSet {
      if on && !tracking {
        backgroundView.backgroundColor = newValue
      }
    }
  }
  
  /*
  *	Sets the background color when the switch is off.
  *   Defaults to clear color.
  */
  @IBInspectable public var inactiveColor: UIColor = UIColor.clearColor() {
    willSet {
      if !on && !tracking {
        backgroundView.backgroundColor = newValue
      }
    }
  }
  
  /*
  *   Sets the background color that shows when the switch is on.
  *   Defaults to green.
  */
  @IBInspectable public var onTintColor: UIColor = UIColor(red: 0.3, green: 0.85, blue: 0.39, alpha: 1) {
    willSet {
      if on && !tracking {
        backgroundView.backgroundColor = newValue
        backgroundView.layer.borderColor = newValue.CGColor
      }
    }
  }
  
  /*
  *   Sets the border color that shows when the switch is off. Defaults to light gray.
  */
  @IBInspectable public var borderColor: UIColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1) {
    willSet {
      if !on {
        backgroundView.layer.borderColor = newValue.CGColor
      }
    }
  }
  
  /*
  *	Sets the knob color. Defaults to white.
  */
  @IBInspectable public var thumbTintColor: UIColor = UIColor.whiteColor() {
    willSet {
      if !userDidSpecifyOnThumbTintColor {
        onThumbTintColor = newValue
      }
      if (!userDidSpecifyOnThumbTintColor || !on) && !tracking {
        thumbView.backgroundColor = newValue
      }
    }
  }
  
  /*
  *	Sets the knob color that shows when the switch is on. Defaults to white.
  */
  @IBInspectable public var onThumbTintColor: UIColor = UIColor.whiteColor() {
    willSet {
      userDidSpecifyOnThumbTintColor = true
      if on && !tracking {
        thumbView.backgroundColor = newValue
      }
    }
  }
  
  /*
  *	Sets the shadow color of the knob. Defaults to gray.
  */
  @IBInspectable public var shadowColor: UIColor = UIColor.grayColor() {
    willSet {
      thumbView.layer.shadowColor = newValue.CGColor
    }
  }
  
  /*
  *	Sets whether or not the switch edges are rounded.
  *   Set to NO to get a stylish square switch.
  *   Defaults to YES.
  */
  @IBInspectable public var isRounded: Bool = true {
    willSet {
      if newValue {
        backgroundView.layer.cornerRadius = frame.size.height * 0.5
        thumbView.layer.cornerRadius = (frame.size.height * 0.5) - 1
      }
      else {
        backgroundView.layer.cornerRadius = 2
        thumbView.layer.cornerRadius = 2
      }
      
      thumbView.layer.shadowPath = UIBezierPath(roundedRect: thumbView.bounds, cornerRadius: thumbView.layer.cornerRadius).CGPath
    }
  }
  
  /*
  *   Sets the image that shows on the switch thumb.
  */
  @IBInspectable public var thumbImage: UIImage! {
    willSet {
      thumbImageView.image = newValue
    }
  }
  
  /*
  *   Sets the image that shows when the switch is on.
  *   The image is centered in the area not covered by the knob.
  *   Make sure to size your images appropriately.
  */
  @IBInspectable public var onImage: UIImage! {
    willSet {
      onImageView.image = newValue
    }
  }
  
  /*
  *	Sets the image that shows when the switch is off.
  *   The image is centered in the area not covered by the knob.
  *   Make sure to size your images appropriately.
  */
  @IBInspectable public var offImage: UIImage! {
    willSet {
      offImageView.image = newValue
    }
  }
  
  /*
  *	Sets the text that shows when the switch is on.
  *   The text is centered in the area not covered by the knob.
  */
  public var onLabel: UILabel!
  
  /*
  *	Sets the text that shows when the switch is off.
  *   The text is centered in the area not covered by the knob.
  */
  public var offLabel: UILabel!
  
  // private
  private var backgroundView: UIView!
  private var thumbView: UIView!
  private var onImageView: UIImageView!
  private var offImageView: UIImageView!
  private var thumbImageView: UIImageView!
  private var currentVisualValue: Bool = false
  private var startTrackingValue: Bool = false
  private var didChangeWhileTracking: Bool = false
  private var isAnimating: Bool = false
  private var userDidSpecifyOnThumbTintColor: Bool = false
  private var switchValue: Bool = false
  
  /*
  *   Initialization
  */
  public init() {
    super.init(frame: CGRectMake(0, 0, 50, 30))
    
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
  
  override public init(frame: CGRect) {
    let initialFrame = CGRectIsEmpty(frame) ? CGRectMake(0, 0, 50, 30) : frame
    super.init(frame: initialFrame)
    
    setup()
  }
  
  
  /*
  *   Setup the individual elements of the switch and set default values
  */
  private func setup() {
    
    // background
    backgroundView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
    backgroundView.backgroundColor = UIColor.clearColor()
    backgroundView.layer.cornerRadius = frame.size.height * 0.5
    backgroundView.layer.borderColor = borderColor.CGColor
    backgroundView.layer.borderWidth = 1.0
    backgroundView.userInteractionEnabled = false
    backgroundView.clipsToBounds = true
    addSubview(backgroundView)
    
    // on/off images
    onImageView = UIImageView(frame: CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height))
    onImageView.alpha = 1.0
    onImageView.contentMode = UIViewContentMode.Center
    backgroundView.addSubview(onImageView)
    
    offImageView = UIImageView(frame: CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height))
    offImageView.alpha = 1.0
    offImageView.contentMode = UIViewContentMode.Center
    backgroundView.addSubview(offImageView)
    
    // labels
    onLabel = UILabel(frame: CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height))
    onLabel.textAlignment = NSTextAlignment.Center
    onLabel.textColor = UIColor.lightGrayColor()
    onLabel.font = UIFont.systemFontOfSize(12)
    backgroundView.addSubview(onLabel)
    
    offLabel = UILabel(frame: CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height))
    offLabel.textAlignment = NSTextAlignment.Center
    offLabel.textColor = UIColor.lightGrayColor()
    offLabel.font = UIFont.systemFontOfSize(12)
    backgroundView.addSubview(offLabel)
    
    // thumb
    thumbView = UIView(frame: CGRectMake(1, 1, frame.size.height - 2, frame.size.height - 2))
    thumbView.backgroundColor = thumbTintColor
    thumbView.layer.cornerRadius = (frame.size.height * 0.5) - 1
    thumbView.layer.shadowColor = shadowColor.CGColor
    thumbView.layer.shadowRadius = 2.0
    thumbView.layer.shadowOpacity = 0.5
    thumbView.layer.shadowOffset = CGSizeMake(0, 3)
    thumbView.layer.shadowPath = UIBezierPath(roundedRect: thumbView.bounds, cornerRadius: thumbView.layer.cornerRadius).CGPath
    thumbView.layer.masksToBounds = false
    thumbView.layer.borderColor = borderColor.CGColor
    thumbView.layer.borderWidth = 1.0
    thumbView.userInteractionEnabled = false
    addSubview(thumbView)
    
    // thumb image
    thumbImageView = UIImageView(frame: CGRectMake(0, 0, thumbView.frame.size.width, thumbView.frame.size.height))
    thumbImageView.contentMode = UIViewContentMode.Center
    thumbImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    thumbView.addSubview(thumbImageView)
    
    on = false
  }
  
  override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    super.beginTrackingWithTouch(touch, withEvent: event)
    
    startTrackingValue = on
    didChangeWhileTracking = false
    
    let activeKnobWidth = bounds.size.height - 2 + 5
    isAnimating = true
    
    UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.BeginFromCurrentState], animations: {
      if self.on {
        self.thumbView.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.thumbView.frame.origin.y, activeKnobWidth, self.thumbView.frame.size.height)
        self.backgroundView.backgroundColor = self.onTintColor
        self.thumbView.backgroundColor = self.onThumbTintColor
      }
      else {
        self.thumbView.frame = CGRectMake(self.thumbView.frame.origin.x, self.thumbView.frame.origin.y, activeKnobWidth, self.thumbView.frame.size.height)
        self.backgroundView.backgroundColor = self.activeColor
        self.thumbView.backgroundColor = self.thumbTintColor
      }
      }, completion: { finished in
        self.isAnimating = false
    })
    
    return true
  }
  
  override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    super.continueTrackingWithTouch(touch, withEvent: event)
    
    // Get touch location
    let lastPoint = touch.locationInView(self)
    
    // update the switch to the correct visuals depending on if
    // they moved their touch to the right or left side of the switch
    if lastPoint.x > bounds.size.width * 0.5 {
      showOn(true)
      if !startTrackingValue {
        didChangeWhileTracking = true
      }
    }
    else {
      showOff(true)
      if startTrackingValue {
        didChangeWhileTracking = true
      }
    }
    
    return true
  }
  
  override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    super.endTrackingWithTouch(touch, withEvent: event)
    
    let previousValue = on
    
    if didChangeWhileTracking {
      setOn(currentVisualValue, animated: true)
    }
    else {
      setOn(!on, animated: true)
    }
    
    if previousValue != on {
      sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
  }
  
  override public func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    
    // just animate back to the original value
    if on {
      showOn(true)
    }
    else {
      showOff(true)
    }
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    
    if !isAnimating {
      let frame = self.frame
      
      // background
      backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
      backgroundView.layer.cornerRadius = isRounded ? frame.size.height * 0.5 : 2
      
      // images
      onImageView.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height)
      offImageView.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height)
      onLabel.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height)
      offLabel.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height)
      
      // thumb
      let normalKnobWidth = frame.size.height - 2
      if on {
        thumbView.frame = CGRectMake(frame.size.width - (normalKnobWidth + 1), 1, frame.size.height - 2, normalKnobWidth)
      }
      else {
        thumbView.frame = CGRectMake(1, 1, normalKnobWidth, normalKnobWidth)
      }
      
      thumbView.layer.cornerRadius = isRounded ? (frame.size.height * 0.5) - 1 : 2
    }
  }
  
  /*
  *   Set the state of the switch to on or off, optionally animating the transition.
  */
  public func setOn(isOn: Bool, animated: Bool) {
    switchValue = isOn
    
    if on {
      showOn(animated)
    }
    else {
      showOff(animated)
    }
  }
  
  /*
  *   Detects whether the switch is on or off
  *
  *	@return	BOOL YES if switch is on. NO if switch is off
  */
  public func isOn() -> Bool {
    return on
  }
  
  /*
  *   update the looks of the switch to be in the on position
  *   optionally make it animated
  */
  private func showOn(animated: Bool) {
    let normalKnobWidth = bounds.size.height - 2
    let activeKnobWidth = normalKnobWidth + 5
    if animated {
      isAnimating = true
      UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.BeginFromCurrentState], animations: {
        if self.tracking {
          self.thumbView.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.thumbView.frame.origin.y, activeKnobWidth, self.thumbView.frame.size.height)
        }
        else {
          self.thumbView.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), self.thumbView.frame.origin.y, normalKnobWidth, self.thumbView.frame.size.height)
        }
        
        self.backgroundView.backgroundColor = self.onTintColor
        self.backgroundView.layer.borderColor = self.onTintColor.CGColor
        self.thumbView.backgroundColor = self.onThumbTintColor
        self.thumbView.layer.borderWidth = 0
        self.onImageView.alpha = 1.0
        self.offImageView.alpha = 0
        self.onLabel.alpha = 1.0
        self.offLabel.alpha = 0
        }, completion: { [weak self] finished in
          self?.isAnimating = false
        })
    }
    else {
      if tracking {
        thumbView.frame = CGRectMake(bounds.size.width - (activeKnobWidth + 1), thumbView.frame.origin.y, activeKnobWidth, thumbView.frame.size.height)
      }
      else {
        thumbView.frame = CGRectMake(bounds.size.width - (normalKnobWidth + 1), thumbView.frame.origin.y, normalKnobWidth, thumbView.frame.size.height)
      }
      
      backgroundView.backgroundColor = onTintColor
      backgroundView.layer.borderColor = onTintColor.CGColor
      thumbView.backgroundColor = onThumbTintColor
      onImageView.alpha = 1.0
      offImageView.alpha = 0
      onLabel.alpha = 1.0
      offLabel.alpha = 0
    }
    
    currentVisualValue = true
  }
  
  /*
  *   update the looks of the switch to be in the off position
  *   optionally make it animated
  */
  private func showOff(animated: Bool) {
    let normalKnobWidth = bounds.size.height - 2
    let activeKnobWidth = normalKnobWidth + 5
    
    if animated {
      isAnimating = true
      UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.BeginFromCurrentState], animations: {
        if self.tracking {
          self.thumbView.frame = CGRectMake(1, self.thumbView.frame.origin.y, activeKnobWidth, self.thumbView.frame.size.height);
          self.backgroundView.backgroundColor = self.activeColor
        }
        else {
          self.thumbView.frame = CGRectMake(1, self.thumbView.frame.origin.y, normalKnobWidth, self.thumbView.frame.size.height);
          self.backgroundView.backgroundColor = self.inactiveColor
        }
        
        self.backgroundView.layer.borderColor = self.borderColor.CGColor
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.layer.borderWidth = 1.0
        self.onImageView.alpha = 0
        self.offImageView.alpha = 1.0
        self.onLabel.alpha = 0
        self.offLabel.alpha = 1.0
        
        }, completion: { [weak self] finished in
          self?.isAnimating = false
        })
    }
    else {
      if (tracking) {
        thumbView.frame = CGRectMake(1, thumbView.frame.origin.y, activeKnobWidth, thumbView.frame.size.height)
        backgroundView.backgroundColor = activeColor
      }
      else {
        thumbView.frame = CGRectMake(1, thumbView.frame.origin.y, normalKnobWidth, thumbView.frame.size.height)
        backgroundView.backgroundColor = inactiveColor
      }
      backgroundView.layer.borderColor = borderColor.CGColor
      thumbView.backgroundColor = thumbTintColor
      onImageView.alpha = 0
      offImageView.alpha = 1.0
      onLabel.alpha = 0
      offLabel.alpha = 1.0
    }
    
    currentVisualValue = false
  }
  
  
}
