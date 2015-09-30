//
//  NTTimePickerComponentView.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/25/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class NTTimePickerComponentView: UIPickerView {

    let label = UILabel()
    
    init(frame: CGRect, type: NTTimePickerComponentViewType, numberWidth: CGFloat) {
        super.init(frame: frame)
        setup(type, numberWidth: numberWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateLabel(row: Int) {
        label.text = row < 10 ? "0\(row)" : "\(row)"
    }
    
    private func setup(type: NTTimePickerComponentViewType, numberWidth: CGFloat) {
        label.textAlignment = .Right
        label.adjustsFontSizeToFitWidth = false
        addSubview(label)

        switch (type) {
        case .Hour:
            label.frame = CGRectMake(0, 0, numberWidth, frame.size.height)
        case .Minute:
            label.frame = CGRectMake(frame.size.width / 2, CGFloat(0), numberWidth, frame.size.height)
        }
    }

}
