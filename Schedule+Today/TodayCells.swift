//
//  TodayCells.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/5/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class TodayCells: UITableViewCell {
    
    @IBOutlet weak var scheduleName: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = self.viewWithTag(1)! as UIView
        view.layer.cornerRadius = 3.0
        
    }
    
    func configureCells(item:SheduleItem){
        scheduleName.text = item.sIName
        dateLabel.text = item.sItemDuration
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}



//#DEFINE_ASSUME_STRING_VARIABLES
let ID_TODAY_CELLS = "TodayCells"
