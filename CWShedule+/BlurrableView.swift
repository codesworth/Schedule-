//
//  BlurrableView.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/22/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class BlurrableView: UIView {

    override func awakeFromNib() {
        blur(thisView: self)
    }

}
