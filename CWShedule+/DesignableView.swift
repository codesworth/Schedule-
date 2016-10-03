//
//  DesignableView.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit


@IBDesignable

class DesignableView: UIView {

    @IBInspectable var borderwith:CGFloat = 0{
        didSet{
            layer.borderWidth = borderwith
            layer.borderColor = UIColor.gray.cgColor
        }
    }
    

    
    

}
