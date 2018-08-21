//
//  ScheduleNotificatios.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/13/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import UserNotifications


let NOTIF_SCHEDULE__TITLE = "Schedule Due"
let NSNOTIF_CATEGORY_ID__ = "ScheduleplusCategory"

class ScheduleNotifications{
    

    
    private static let  _notification = ScheduleNotifications()
    
    static var notification:ScheduleNotifications{
        return _notification
    }
    
    func removeNotification(item:SheduleItem){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(item.sItemID)"])
    }
    
    func callBack(item:SheduleItem){
        let interval = returnInterval(item: item)
        if interval != nil{
            let interval = returnInterval(item: item)
            let timeInterval = TimeInterval(exactly: interval!)
            let newDate = item.sIBeginDate?.addingTimeInterval(timeInterval!)
            rescheduleNotifications(item: item, date: newDate!)
        }
        
    }
    
    
    func reScheduleNotification(item:SheduleItem){
        removeNotification(item: item)
        let newDate = NSDate().addingTimeInterval(600)
        let content = UNMutableNotificationContent()
        content.title = NOTIF_SCHEDULE__TITLE
        content.body = item.sIName!
        content.userInfo = ["extraNote":item.childSDetails?.sDExtraDetails ?? "Nothing Here", "timing":item.sIBeginDate!, "itemID":item.sItemID]
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = NSNOTIF_CATEGORY_ID__
        let calender = Calendar(identifier: .gregorian)
        let components = calender.dateComponents([.month, .day, .hour, .minute], from: newDate as Date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "\(item.sItemID)", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            
        })

    }
    func shouldScheduleNotification(item:SheduleItem){
        
        removeNotification(item: item)
        
        if (item.childSUrgency?.sUSetReminder)! && item.sIBeginDate as! Date > Date(){
            print("Notif will be fired")
            let content = UNMutableNotificationContent()
            content.title = NOTIF_SCHEDULE__TITLE
            content.body = item.sIName!.capitalized
            content.userInfo = ["extraNote":item.childSDetails?.sDExtraDetails ?? "Nothing Here", "timing":item.sIEndDate ?? nil ?? NSDate(), "itemID":item.sItemID]
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = NSNOTIF_CATEGORY_ID__
            let calender = Calendar(identifier: .gregorian)
            var trigger:UNCalendarNotificationTrigger
            if (item.childSUrgency?.sURepeat)! > 4{
                let components = calender.dateComponents([.month, .day, .hour, .minute], from: item.sIBeginDate as! Date)
                
                trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            }else{
                let components = dateComponent(item: item, calendar: calender)
                trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            }

            let request = UNNotificationRequest(identifier: "\(item.sItemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: { (error) in
                //
            })
        }
    
    }
    
    func rescheduleNotifications(item:SheduleItem, date:NSDate){
        let content = UNMutableNotificationContent()
        content.title = NOTIF_SCHEDULE__TITLE
        content.body = item.sIName!
        content.sound = UNNotificationSound.default()
        let calender = Calendar(identifier: .gregorian)
        let components = calender.dateComponents([.month, .day, .hour, .minute], from: date as Date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "\(item.sItemID)", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            //
        })

    }
    
    private func returnInterval(item:SheduleItem)->Double?{
        if item.childSUrgency?.sURepeat == 0{
            return 3600
        }else if item.childSUrgency?.sURepeat == 1{
            return 86400
        }else if item.childSUrgency?.sURepeat == 2{
            return 2592000
        }else if item.childSUrgency?.sURepeat == 3{
            return 31536000
        }else{
            return nil
        }
    }
}



extension ScheduleNotifications{
    func dateComponent(item:SheduleItem,calendar:Calendar)->DateComponents{
        var component:DateComponents
        let repeatInterval = item.childSUrgency?.sURepeat
        switch repeatInterval! {
        case 0:
           component = calendar.dateComponents([.minute], from: item.sIBeginDate! as Date)
            break
        case 1:
            component = calendar.dateComponents([.hour,.minute], from: item.sIBeginDate! as Date)
            break
        case 2:
            component = calendar.dateComponents([.day,.hour,.minute], from: item.sIBeginDate! as Date)
            break
        case 3:
            component = calendar.dateComponents([.weekOfMonth,.day,.hour,.minute], from: item.sIBeginDate! as Date)
            break
        case 4:
            component = calendar.dateComponents([.month, .weekOfMonth, .day, .hour, .minute], from: item.sIBeginDate! as Date)
        default:
            component = DateComponents()
        }
        return component
    }
}



class CWDateComponents:NSDateComponents{
    
    var dayOfYear:Int?
    
    
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func returnDayOfYear(){
        let cal = Calendar.current
        let day = cal.ordinality(of: .day, in: .year, for: Date())
        self.dayOfYear = day
    }
    
    
    
    
    
    
    
    
    
}














