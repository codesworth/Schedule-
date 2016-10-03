//
//  SheduleGroupVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData

class SheduleGroupVC: UIViewController, UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController:NSFetchedResultsController<SheduleGroup>!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        do {
            try tryFetch()
        } catch let error as NSError {
            print("error : ", error.debugDescription)
        }
        //generateTestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    
    //MARK: - COREDATA
    
    func tryFetch() throws{
        
        
        let fetchRequest:NSFetchRequest<SheduleGroup> = SheduleGroup.fetchRequest()
        let dateSorting = NSSortDescriptor(key: "sGcreatedDate", ascending: false)
        
        fetchRequest.sortDescriptors = [dateSorting]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch let error as NSError{
            print("Eror occurred here with Signature: ", error.debugDescription)
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as? SheduleGroupCell
                configureCell(cell: cell!, indexPath: indexPath as NSIndexPath)
            }
            break
        }
    }
    
    
    
   //MARK : - FUNCTIONS
    
    func configureCell(cell:SheduleGroupCell, indexPath:NSIndexPath){
        let scheduleGroup = fetchedResultsController.object(at: indexPath as IndexPath)
        cell.updateSGCellUI(sheduleGroup: scheduleGroup)
    }
    
    
    
    
    
    
    
    //MARK :- TABLEVIEW DELEGATES
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            let userInfo = sections[section]
            return userInfo.numberOfObjects
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDENTIFIER_S_GROUP, for: indexPath) as? SheduleGroupCell{
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            return cell
        }
        return SheduleGroupCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scheduleItem = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: SEGUE_SHEDULE_GROUP_ITEMS, sender: scheduleItem)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath)  in
            let scheduleGroup = self.fetchedResultsController.object(at: indexPath)
            self.performSegue(withIdentifier: SEGUE_EDIT_SG, sender: scheduleGroup)
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let scheduleGroup = self.fetchedResultsController.object(at: indexPath)
            context?.delete(scheduleGroup)
            appDelegate?.saveContext()
            
            tableView.reloadData()
            
        }
        editAction.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.9)
        deleteAction.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        return [editAction,deleteAction]
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_EDIT_SG{
            if let destination = segue.destination as? ScheduleGroupDetail{
                if let scheduleGroup = sender as? SheduleGroup{
                    destination.scheduleGroupToEdit = scheduleGroup
                }
            }
        }
        else if segue.identifier == SEGUE_SHEDULE_GROUP_ITEMS{
            if let destination = segue.destination as? ScheduleItemVC{
                if let scheduleItem = sender as? SheduleGroup{
                    destination.scheduleGroup = scheduleItem
                }
            }
        }
    }
    
    
    func generateTestData(){
        let sg1 = SheduleGroup(context: context!)
        sg1.sGName = "Recreational"
        let sg2 = SheduleGroup(context: context!)
        sg2.sGName = "Projects"
        let sg3 = SheduleGroup(context: context!)
        sg3.sGName = "Work"
        let sg4 = SheduleGroup(context: context!)
        sg4.sGName = "Chores Ashley"
        let sg5 = SheduleGroup(context: context!)
        sg5.sGName = "Family"
        let sg6 = SheduleGroup(context: context!)
        sg6.sGName = "Home"
        let sg7 = SheduleGroup(context: context!)
        sg7.sGName = "Miscellaneous"
        appDelegate?.saveContext()
        
        
    }

}
