//
//  PersistentContainer.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/23/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData

class PersistentContainer: NSPersistentContainer {
    
    override class func defaultDirectoryURL() -> URL{
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.codesworth.CWSchedule-")!
    }
    
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
    }
    
    
    
}
