//
//  RepeatDateSelectionTableViewCell.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class RepeatDateSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkIconImageView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(dateNumber: Int, repeatDate: RepeatDate?) {
        // Get Date string
        if let date = NumberToDate(dateNumber: dateNumber) {
            // Get Date name and set to dateLabel
            dateLabel.text = date.simpleDescription
            // Get isRepeat
            if let rDate = repeatDate {
                checkIconImageView.hidden = !date.getIsRepeat(rDate)
            } else {
                checkIconImageView.hidden = true
            }
        }
        
    }

}
