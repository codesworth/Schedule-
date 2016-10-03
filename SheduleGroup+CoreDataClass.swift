//
//  SheduleGroup+CoreDataClass.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData


public class SheduleGroup: NSManagedObject {
    
    public override func awakeFromInsert() {
        self.sGcreatedDate = Date() as NSDate
    }
}
