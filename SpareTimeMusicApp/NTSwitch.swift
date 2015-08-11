//
//  NTSwitch.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/5/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation
import UIKit

class NTSwitch: SevenSwitch {
    
    override init() {
        super.init()
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.onTintColor = UIColor.untAzulColor()
        self.borderColor = UIColor(white: 1, alpha: 0.41)
        self.shadowColor = UIColor.untTransparentColor()
        self.thumbTintColor = UIColor.untTransparentColor()
        self.onThumbTintColor = UIColor.whiteColor()
    }
    
}
