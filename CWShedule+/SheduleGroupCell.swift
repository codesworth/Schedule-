//
//  SheduleGroupCell.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class SheduleGroupCell: UITableViewCell {
    
    @IBOutlet weak var sheduleGroupImageView: UIImageView!
    
    @IBOutlet weak var scheduleGroupName: UILabel!
    
    @IBOutlet weak var sheduleItemRemaining: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func updateSGCellUI(sheduleGroup:SheduleGroup){
        scheduleGroupName.text = sheduleGroup.sGName
        sheduleGroupImageView.image = sheduleGroup.childSImages?.sImages as? UIImage
    }

}
