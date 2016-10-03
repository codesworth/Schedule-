//
//  HomeVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/2/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData
class HomeVC: UIViewController, UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController:NSFetchedResultsController<SheduleItem>!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var completedView: UIView!
    @IBOutlet var completionView: UIView!
    var did = false
    var upComingSchedules:[SheduleItem]!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tryFetching()
    }
    

    
    func tryFetching(){
        let fetchRequest:NSFetchRequest<SheduleItem> = SheduleItem.fetchRequest()
        let dateSorting = NSSortDescriptor(key: "sIcreatedDate", ascending: false)
        fetchRequest.sortDescriptors = [dateSorting]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }catch let error as NSError{
            print(error.debugDescription)
    }
        
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func configureCell(cell:UpcomingCells, indexPath:IndexPath){
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_UPCOMING_ITEM_DETAILS{
            if let destination = segue.destination as? AddScheduleItemVC{
                if let item = sender as? SheduleItem{
                    destination.sheduleItemToEdit = item
                }
            }
        }
    }
    
    
    

}


extension HomeVC{
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if let sections = fetchedResultsController.sections{
            let user = sections[section]
            return user.numberOfObjects
        }*/
        return 10
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = fetchedResultsController.object(at: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: RE_USE_IDENTIFIER_UPCOMING_CELL, for: indexPath) as? UpcomingCells{
            cell.updateUpcoming(item: item)
            return cell
        }else{
            return UpcomingCells()
        }
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: SEGUE_UPCOMING_ITEM_DETAILS, sender: item)
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}






