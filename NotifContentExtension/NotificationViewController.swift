//
//  NotificationViewController.swift
//  NotifContentExtension
//
//  Created by Mensah Shadrach on 12/2/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

//func dateDayFormat(date:NSDate) ->String{
//    let dateformatter = DateFormatter()
//    dateformatter.dateStyle = .short
//    dateformatter.dateFormat = "yyy-MM-dd"
//    let formatedDate = dateformatter.string(from: date as Date)
//    return formatedDate
//}

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    
    @IBOutlet weak var notifTitleLabel: UILabel!
    
    @IBOutlet weak var notifExtraNote: UILabel!
    
    @IBOutlet weak var notifTiminglabel: UILabel!
    var itemID:Int64!
    var completed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.frame.size.height = 1
        //UNNotificationContentExtension
        // Do any required interface initialization here.
    }
    
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        itemID = content.userInfo["itemID"] as! Int64
        notifTitleLabel.text = "Schedule Due"
        notifExtraNote.text = notification.request.content.body.capitalized
        let date = content.userInfo["timing"] as? NSDate
        guard date == nil else{
          let formatteddated = dateDayFormat(date: date!)
            notifTiminglabel.text = "Ending \(formatteddated)"
            return
        }
        notifTiminglabel.text = "Starting now"
        
    }
    
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == ID_CWNOTIF_ACTION_RESCHED__{
            
            completion(.dismissAndForwardAction)

        }else if response.actionIdentifier == ID_CWNOTIF_ACTION_MARK_COMPLTD__{
            completed = true
            completion(.dismissAndForwardAction)
        }else if response.actionIdentifier == ID_CWNOTIF_ACTION_SNOOZE{
            completion(.dismissAndForwardAction)
        }
    }


}


