//
//  UpcomingCells.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/2/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class UpcomingCells: UITableViewCell {
    
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUpcoming(item:SheduleItem){
        itemLabel.text = item.sIName
        itemTimeLabel.text = item.sItemDuration
    }
}
