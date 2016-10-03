//
//  ScheduleItemCell.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/21/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class ScheduleItemCell:MGSwipeTableCell {

    @IBOutlet weak var sIDurationLabel: UILabel!
    @IBOutlet weak var sItemNameLabel: UILabel!
    @IBOutlet weak var sICheckmarkView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateSItemUI(item:SheduleItem){
        sItemNameLabel.text = item.sIName
        sIDurationLabel.text = item.sItemDuration
    }
    
    func configureCheck(checked:Bool){
        if checked{
            sICheckmarkView.image = UIImage(named: NAME_OF_IMAGE_CHECKED)
        }else{
            sICheckmarkView.image = UIImage(named: NAME_OF_IMAGE_UNCHECKED)
        }
    }

}
