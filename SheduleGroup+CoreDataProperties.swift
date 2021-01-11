//
//  SheduleGroup+CoreDataProperties.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData


extension SheduleGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SheduleGroup> {
        return NSFetchRequest<SheduleGroup>(entityName: "SheduleGroup");
    }

    @NSManaged public var sGName: String?
    @NSManaged public var sGcreatedDate: NSDate?
    @NSManaged public var childSItems: NSOrderedSet?
    @NSManaged public var childSImages: ScheduleImages?

}

// MARK: Generated accessors for childSItems
extension SheduleGroup {

    @objc(addChildSItemsObject:)
    @NSManaged public func addToChildSItems(_ value: SheduleItem)

    @objc(removeChildSItemsObject:)
    @NSManaged public func removeFromChildSItems(_ value: SheduleItem)

    @objc(addChildSItems:)
    @NSManaged public func addToChildSItems(_ values: NSSet)

    @objc(removeChildSItems:)
    @NSManaged public func removeFromChildSItems(_ values: NSSet)

}
