//
//  CoreService.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 11/13/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData




class CoreService{
    
    private static let _service = CoreService()
    
    static var service:CoreService{
        return _service
    }
    
    
    func performFetchFromSearch(string:String,itemName:String)->[SheduleItem?]{
        var searchResult = [SheduleItem?]()
        searchResult = []
        let fetchRequest:NSFetchRequest<NSFetchRequestResult>!
        let predicate = NSPredicate(format: "\(itemName) CONTAINS[c] %@", string)
        let model = context.persistentStoreCoordinator?.managedObjectModel
        fetchRequest = model?.fetchRequestTemplate(forName: "ItemFetch")?.copy() as? NSFetchRequest
        fetchRequest.predicate = predicate
        do{
            searchResult = try context.fetch(fetchRequest) as! [SheduleItem]
            //print(searchResult)
        }catch let error as NSError{
            print(error.debugDescription)
        }
        return searchResult
    }
    
     func fetchScheduleGroup(name:String)->[SheduleGroup?]{
        var sgroup = [SheduleGroup?]()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult>!
        let predicate = NSPredicate(format: "sGName like[c] %@", name)
        let model = context.persistentStoreCoordinator?.managedObjectModel
        fetchRequest = model?.fetchRequestTemplate(forName: "groupFetchrequest")?.copy() as? NSFetchRequest
        fetchRequest.predicate = predicate
        do {
            let group = try context.fetch(fetchRequest) as? [SheduleGroup]
            sgroup = group!
            print(sgroup)
        } catch let error {
            print(error)
        }
        return sgroup
    }
    
    func performFetchwith(itemID:Int64)->SheduleItem{
        var searchResult = [SheduleItem?]()
        //searchResult = []
        let fetchRequest:NSFetchRequest<NSFetchRequestResult>!
        let predicate = NSPredicate(format: "sItemID == %D", itemID)
        let model = context.persistentStoreCoordinator?.managedObjectModel
        fetchRequest = model?.fetchRequestTemplate(forName: "NotifFetch")?.copy() as? NSFetchRequest
        fetchRequest.predicate = predicate
        do{
           searchResult = try context.fetch(fetchRequest) as! [SheduleItem]
            //print(searchResult)
        }catch let error as NSError{
            print(error.debugDescription)
        }
        return searchResult[0]!
    }
    
    
    
}




