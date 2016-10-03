//
//  ScheduleUrgency+CoreDataProperties.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData


extension ScheduleUrgency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleUrgency> {
        return NSFetchRequest<ScheduleUrgency>(entityName: "ScheduleUrgency");
    }

    @NSManaged public var sUSetReminder: Bool
    @NSManaged public var sUUrgency: Int64
    @NSManaged public var sURepeat: Int64
    @NSManaged public var childSItems: SheduleItem?

}
