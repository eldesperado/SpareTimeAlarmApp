//
//  RepeatDateSelectionTableViewCell.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 8/10/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

protocol NumberToDateProtocol {
    var simpleDescription: String { get }
}

enum NumberToDate: Int, NumberToDateProtocol {
    case Monday = 0, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    var simpleDescription: String {
        get {
            return self.getDescription()
        }
    }
    
    private func getDescription() -> String {
        switch self {
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        case .Sunday:
            return "Sunday"
        }
    }
    
    func getIsRepeat(repeatDate: RepeatDate) -> Bool {
        switch self {
        case .Monday:
            return repeatDate.isMon.boolValue
        case .Tuesday:
            return repeatDate.isTue.boolValue
        case .Wednesday:
            return repeatDate.isWed.boolValue
        case .Thursday:
            return repeatDate.isThu.boolValue
        case .Friday:
            return repeatDate.isFri.boolValue
        case .Saturday:
            return repeatDate.isSat.boolValue
        case .Sunday:
            return repeatDate.isSun.boolValue
        }
    }
}

class RepeatDateSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(dateNumber: Int, repeatDate: RepeatDate?) {
        // Get Date string
        if let date = NumberToDate(rawValue: dateNumber) {
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
