//
//  RepeatCells.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/22/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class RepeatCells: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(arrayObject:String){
        nameLabel.text = arrayObject
    }
    
    func configureAccessoryView(value:Bool){
        if value && accessoryType != .checkmark{
            self.accessoryType = .checkmark
        }else{
            self.accessoryType = .none
        }
    }

}
