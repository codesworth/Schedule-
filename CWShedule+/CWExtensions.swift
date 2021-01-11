//
//  CWExtensions.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 2/22/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import UIKit

extension UIView{
    
    func rotate360Degrees(_ duration:CFTimeInterval = 1, completionDelegate:AnyObject? = nil){
        let rotationAnimation = CABasicAnimation(keyPath: KEY_PATH_CA_ANIM_ROTATE)
        rotationAnimation.fromValue = 0.00
        rotationAnimation.toValue = CGFloat(M_PI * 2)
        rotationAnimation.duration = duration
        if let delegate:AnyObject = completionDelegate{
            rotationAnimation.delegate = delegate as? CAAnimationDelegate
        }
        
        self.layer.add(rotationAnimation, forKey: nil)
    }
}





extension Date{
    func dateFormat()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E HH:mm"
        return dateFormatter.string(from: self)
    }
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let formattedDate = dateFormatter.string(from:self)
        return formattedDate
    }
    
    func monthAndDayFromat()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "EEE, MMM d"
        let formattedDate = dateFormatter.string(from:self)
        return formattedDate
    }
    
    func date_no_time()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    func date_no_time_2()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
}
public extension UISearchBar{
    
    func setTextColor(color:UIColor){
        let barSubviews = subviews.flatMap{ $0.subviews
        }
        guard let textSubview =  (barSubviews.filter({ $0 is UITextField})).first as? UITextField else{return}
        textSubview.textColor = color
    }
}




class Timer {
    var timer = Foundation.Timer()
    let duration: Double
    let completionHandler: () -> ()
    fileprivate var elapsedTime: Double = 0.0
    
    init(duration: Double, completionHandler: @escaping () -> ()) {
        self.duration = duration
        self.completionHandler = completionHandler
    }
    
    func start() {
        self.timer = Foundation.Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Timer.tick), userInfo: nil, repeats: true)
    }
    
    func stop() {
        self.timer.invalidate()
    }
    
    @objc fileprivate func tick() {
        self.elapsedTime += 1.0
        if self.elapsedTime == self.duration {
            self.stop()
            self.completionHandler()
            self.elapsedTime = 0.0
        }
    }
    
    deinit {
        self.stop()
    }
    

}




