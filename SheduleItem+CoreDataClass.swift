//
//  SheduleItem+CoreDataClass.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData


public class SheduleItem: NSManagedObject {
    
    func nextSheduleItemID()-> Int{
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ScheduleItemID")
        userDefaults.set(itemID+1, forKey: "ScheduleItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    public override func awakeFromInsert() {
        self.sIcreatedDate = Date() as NSDate
        self.sItemID = Int64(nextSheduleItemID())
        self.sItemChecked = false
        
    }
    
    public override func prepareForDeletion() {
        ScheduleNotifications.notification.removeNotification(item: self)
    }
    
    public override func awakeFromFetch() {
        
    }
}
