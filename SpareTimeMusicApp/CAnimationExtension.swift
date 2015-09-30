//
//  CAimationExtension.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/21/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

extension CATransform3D {

    func rotationZ() -> CGFloat
    {
        return atan2(m12, m11)
    }

}


extension CALayer {
    func animateThemeChangeAnimation() {
        let animation: CATransition = CATransition()
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        
        addAnimation(animation, forKey: nil)
    }

}