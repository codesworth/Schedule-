//
//  ScheduleDetails+CoreDataProperties.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData
 

extension ScheduleDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleDetails> {
        return NSFetchRequest<ScheduleDetails>(entityName: "ScheduleDetails");
    }

    @NSManaged public var sDExtraDetails: String?
    @NSManaged public var childSItems: SheduleItem?

}
