//
//  ScheduleImages+CoreDataProperties.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData
 

extension ScheduleImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleImages> {
        return NSFetchRequest<ScheduleImages>(entityName: "ScheduleImages");
    }

    @NSManaged public var sImages: NSObject?
    @NSManaged public var childSGroup: SheduleGroup?

}
