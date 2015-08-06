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
        self.onTintColor = UIColor(red: 43.0/255.0, green: 100.0/255.0, blue: 243.0/255.0, alpha: 1)
        self.borderColor = UIColor(white: 1, alpha: 0.41)
        self.shadowColor = UIColor.clearColor()
        self.thumbTintColor = UIColor.clearColor()
        self.onThumbTintColor = UIColor.whiteColor()
    }
    
}
