//
//  CalenderCells.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/6/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class CalenderCells: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemGroupLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCalendarCellsUI(item:SheduleItem){
        itemNameLabel.text = item.sIName
        if item.childSGroup == nil{
            itemGroupLabel.text = "*No Group*"
        }else{
            itemGroupLabel.text = item.childSGroup?.sGName
        }
        let date = item.sIBeginDate!
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "HH"
        hourLabel.text = dateFormatter.string(from: date as Date)
        let newformat = DateFormatter()
        newformat.dateFormat = "mm"
        minuteLabel.text = newformat.string(from: date as Date)
        
    }

}



