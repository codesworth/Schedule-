//
//  SheduleItem+CoreDataProperties.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData
 

extension SheduleItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SheduleItem> {
        return NSFetchRequest<SheduleItem>(entityName: "SheduleItem");
    }

    @NSManaged public var sIName: String?
    @NSManaged public var sIBeginDate: NSDate?
    @NSManaged public var sIcreatedDate: NSDate?
    @NSManaged public var sIEndDate: NSDate?
    @NSManaged public var sItemID: Int64
    @NSManaged public var sItemChecked: Bool
    @NSManaged public var sItemDuration:String?
    @NSManaged public var childSDetails: ScheduleDetails?
    @NSManaged public var childSUrgency: ScheduleUrgency?
    @NSManaged public var childSGroup: SheduleGroup?
    @NSManaged public var sCalenderID:String?
}
