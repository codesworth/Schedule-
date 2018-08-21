//
//  CoredataStack.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/5/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData


class CoreDataStack{
    
    
    static var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle(for: CoreDataStack.self).url(forResource: "CWShedule_", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    
    static var persistentContainer:PersistentContainer = {
        let container = PersistentContainer(name: "CWShedule_", managedObjectModel: CoreDataStack.managedObjectModel)
        container.loadPersistentStores(completionHandler: { (storeDescription:NSPersistentStoreDescription, error:Error?) in
            if let error = error as NSError?{
                fatalError("UnResolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = CoreDataStack.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                //CoreDataStack.persistentContainer.persistentStoreCoordinator
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}




/*static var persistentContainer: NSPersistentContainer = {
 
 
 /*let container = NSPersistentContainer(name: "CWShedule_")
 container.loadPersistentStores(completionHandler: { (storeDescription, error) in
 if let error = error as NSError? {
 // Replace this implementation with code to handle the error appropriately.
 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
 
 /*
 Typical reasons for an error here include:
 * The parent directory does not exist, cannot be created, or disallows writing.
 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
 * The device is out of space.
 * The store could not be migrated to the current model version.
 Check the error message to determine what the actual problem was.
 */
 fatalError("Unresolved error \(error), \(error.userInfo)")
 }
 })*/
 return container
 
 }()*/

//CWShedule_
