//
//  PasscodeNotif.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/23/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import UIKit

class PasscodeNotifObserver{
    
    class func showPasscodeView(ViewContoller:UIViewController){
        NotificationCenter.default.addObserver(ViewContoller, selector: #selector(presentPasscodeView(view:)), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
     @objc func presentPasscodeView(view:UIViewController){
        let passview = view.storyboard?.instantiateViewController(withIdentifier: __STORY_ID_PASCODE__)
        view.present(passview!, animated: false, completion: nil)
    }
}
