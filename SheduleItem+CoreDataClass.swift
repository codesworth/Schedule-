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
    
    public override func awakeFromInsert() {
        self.sIcreatedDate = Date() as NSDate
        self.sItemID = Int64(nextSheduleItemID())
        self.sItemChecked = false
    }
}
