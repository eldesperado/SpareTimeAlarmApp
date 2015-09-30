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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(dateNumber: Int, repeatDate: RepeatDate?) {
        // Get Date string
        if let date = NumberToDate(dateNumber: dateNumber) {
            // Get Date name and set to dateLabel
            self.dateLabel.text = date.simpleDescription
            // Get isRepeat
            if let rDate = repeatDate {
                self.checkIconImageView.hidden = !date.getIsRepeat(rDate)
            } else {
                self.checkIconImageView.hidden = true
            }
        }
        
    }

}
