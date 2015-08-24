//
//  SpringAnimation.swift
//  Example
//
//  Created by Wojciech Lukaszuk on 06/09/14.
//  Copyright (c) 2014 Wojtek Lukaszuk. All rights reserved.
//

import QuartzCore

class SpringAnimation: CAKeyframeAnimation
{
    var damping: CGFloat = 10.0
    var mass: CGFloat = 1.0
    var stiffness: CGFloat = 300.0
    var velocity: CGFloat = 0
    var fromValue: CGFloat = 0.0
    var toValue: CGFloat = 0.0
    
    override func copyWithZone(zone: NSZone) -> AnyObject
    {
        var copy = super.copyWithZone(zone) as! SpringAnimation
        
        self.duration = self.durationForEpsilon(0.01)
        copy.values = self.interpolatedValues()
        copy.duration = self.duration
        copy.mass = self.mass
        copy.stiffness = self.stiffness
        copy.damping = self.damping
        copy.velocity = self.velocity
        copy.fromValue = self.fromValue
        copy.toValue = self.toValue
        
        return copy
    }
    
    func interpolatedValues() -> [CGFloat]
    {
        var values: [CGFloat] = []
        var value: CGFloat = 0
        var valuesCount: Int = Int(self.duration * 60)
        var ω0: CGFloat = sqrt(self.stiffness / self.mass)  // angular frequency
        var β: CGFloat = self.damping / (2 * self.mass)     // amount of damping
        var v0 : CGFloat = self.velocity
        var x0: CGFloat = 1 // substituted initial value
        
        for i in 0..<valuesCount {
            
            var t: CGFloat = CGFloat(i)/60.0
            
            if β < ω0 {
                // underdamped
                var ω1: CGFloat = sqrt(ω0 * ω0 - β * β)
                
                value = exp(-β * t) * (x0 * cos(ω1 * t) + CGFloat((β * x0 + v0) / ω1) * sin(ω1 * t))
            } else if β == ω0  {
                // critically damped
                value = exp(-β * t) * (x0 + (β * x0 + v0) * t)
            }
            else {
                // overdamped
                var ω2: CGFloat = sqrt(β * β - ω0 * ω0)
                let sinhVal = sinh( ω2 * t)
                let coshVal = cosh(CGFloat(ω2 * t))
                value = exp(-β * t) * (x0 * coshVal + ((β * x0 + v0) /  ω2) * sinhVal)
            }
            
            values.append(self.toValue - value * (self.toValue - self.fromValue))
        }
        
        return values
    }
    
    func durationForEpsilon(epsilon: CGFloat) -> CFTimeInterval
    {
        var beta: CGFloat = self.damping / (2 * self.mass)
        var duration: CGFloat = 0
        
        while exp(-beta * duration) >= epsilon {
            duration += 0.1
        }
        
        return CFTimeInterval(duration)
    }
}