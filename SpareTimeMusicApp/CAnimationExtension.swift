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
        return atan2(self.m12, self.m11)
    }

}