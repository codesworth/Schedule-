//
//  CWSpeechDelegate.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/30/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData

class CWScheduleStats:NSObject{
    
    private static let _mainStats = CWScheduleStats()
    
    static var mainStats:CWScheduleStats{
        return _mainStats
    }
    
    var items = [SheduleItem?]()
    var uncompleted = 0
    var completed = 0
    var dueToday = 0
    var overdue = 0
    var completionPercentage:Double = 0
    
     func resetStatisticData(){
         uncompleted = 0
         completed = 0
         dueToday = 0
         overdue = 0
         completionPercentage = 0
    }
    
    
    func computeStatistics(){
        resetStatisticData()
       items = performFetch()
        computeCompleted()
        calculateOverDue()
        calculateDuetoday()
        calculateCompletionStats()
        calcompletenPercentage()

    }
    
    private func performFetch()->[SheduleItem?]{
        var searchResult = [SheduleItem?]()
        searchResult = []
        let fetchRequest:NSFetchRequest<NSFetchRequestResult>!
        let model = context.persistentStoreCoordinator?.managedObjectModel
        fetchRequest = model?.fetchRequestTemplate(forName: "allItemFetch")?.copy() as? NSFetchRequest
        do{
            searchResult = try context.fetch(fetchRequest) as! [SheduleItem]
        }catch let error as NSError{
            print(error.debugDescription)
        }
        return searchResult
    }
    
    private func computeCompleted(){
       
        for item in items{
        computeCompleted(item: item!)
        }
    }
    
    private func calculateCompletionStats(){
        let items = performFetch()
        for item in items{
            let date = item?.sIEndDate
            if item?.sIEndDate != nil {

                if dateIsPast(date: date!){
                if (item!.sItemChecked) == false{
                       uncompleted += 1
                    }
                }
                else{
                    //what to do if date be not past
                }
            }
            
        }
    }
    
    private func dateIsPast(date:NSDate)->Bool{
        if date.compare(NSDate() as Date) == ComparisonResult.orderedAscending{
            return true
        }
        return false
    }
    
    private func computeCompleted(item:SheduleItem){
        if item.sItemChecked{
            completed += 1
        }
    }
    
    
    private func calculateOverDue(){
        for item in items{
            if item?.sIBeginDate != nil{
    
                if dateIsPast(date: item!.sIBeginDate!) && !(item!.sItemChecked){
                    overdue += 1
                }
            
            }
        }
    }
    
    private func calculateDuetoday(){
        for item in items{
            if let itemDate = item?.sIBeginDate {
                if date(date1: itemDate, isSameDayAs: NSDate()){
                    dueToday += 1
                }
            }
        }
    }
    
    private func calcompletenPercentage(){
        if completed == 0{
            completionPercentage = 0
            return
        }
        completionPercentage =  (Double(completed ) / Double(uncompleted + completed)) * 100
    }
    
    public func date(date1:NSDate, isSameDayAs date2:NSDate)->Bool{
        let calendar = Calendar(identifier: .gregorian)
        let component1 = calendar.dateComponents([.year, .month, .day], from: date1 as Date)
        let component2 = calendar.dateComponents([.year, .month, .day], from: date2 as Date)
        return(component1.year == component2.year && component1.month == component2.month && component1.day == component2.day)
        
    }
  
    
}
