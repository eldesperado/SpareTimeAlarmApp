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
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    onTintColor = UIColor.untAzulColor()
    borderColor = UIColor(white: 1, alpha: 0.41)
    shadowColor = UIColor.untTransparentColor()
    thumbTintColor = UIColor.untTransparentColor()
    onThumbTintColor = UIColor.whiteColor()
  }
  
}
