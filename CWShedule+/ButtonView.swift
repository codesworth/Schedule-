//
//  ButtonView.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 11/9/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class ButtonView: UIButton {

    override func awakeFromNib() {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
    }

}
