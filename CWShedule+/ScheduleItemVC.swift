//
//  ScheduleItemVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/21/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData

class ScheduleItemVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate, MGSwipeTableCellDelegate {

    @IBOutlet weak var addSIButton: UIButton!
    @IBOutlet weak var sGImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var checked = false
    var check = true
    var fetchedResultsController:NSFetchedResultsController<SheduleItem>!
    var scheduleGroup:SheduleGroup!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = scheduleGroup.sGName
        tableView.delegate = self
        tableView.dataSource = self
        sGImageView.image = scheduleGroup.childSImages?.sImages as? UIImage
        
        //generatedata()
        
        /*do {
            try tryFetch()
        } catch let error as NSError {
            print("Horrible turn of events: ", error.debugDescription)
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    

    //MARK: - COREDATA
    /*func tryFetch() throws{
        let scheduleItems = scheduleGroup.childSItems
        //let fetchRequest:NSFetchRequest<SheduleItem> = scheduleGroup.childSItems.fetchRequest()
        let dateSorting = NSSortDescriptor(key: "sIcreatedDate", ascending: false)
        
        fetchRequest.sortDescriptors = [dateSorting]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch let error as NSError{
            print("Eror occurred here with Signature: ", error.debugDescription)
        }
    }*/
    
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
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as? ScheduleItemCell
                configureCells(cell: cell!, indexPath: indexPath as NSIndexPath)
            }
            break
        }

    }
    
    
    
    
    
    
    
    
    
    //MARK: - TABLE VIEW IMPLEMENTATION
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (scheduleGroup.childSItems?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDENTIFIER_S_ITEM, for: indexPath) as? ScheduleItemCell{
            configureCells(cell: cell, indexPath: indexPath as NSIndexPath)
            cell.delegate = self
            return cell
        }
        return ScheduleItemCell()
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = scheduleGroup.childSItems?[indexPath.row] as! SheduleItem
        context?.delete(item)
        appDelegate?.saveContext()
        tableView.reloadData()
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let item = scheduleGroup.childSItems?[indexPath.row] as! SheduleItem
        self.performSegue(withIdentifier: SEGUE_SCHEDULE_ITEM_DETAILS, sender: item)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //
    }
    
    
    func swipeTableCell(_ cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection, from point: CGPoint) -> Bool {
        return true
    }
    
    
    func swipeTableCell(_ cell: MGSwipeTableCell!, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [Any]! {
        swipeSettings.transition = MGSwipeTransition.static
        expansionSettings.buttonIndex = 0
        if direction == .rightToLeft{
            expansionSettings.fillOnTrigger = true
            expansionSettings.buttonIndex = 0
            expansionSettings.expansionColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.9)
            expansionSettings.threshold = 4.0
            return [ MGSwipeButton(title: "Delete", backgroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 1), callback: { (cell:MGSwipeTableCell?) -> Bool in
                let indexPath = self.tableView.indexPath(for: cell!)
                let item = self.scheduleGroup.childSItems?[(indexPath?.row)!] as? SheduleItem
                context?.delete(item!)
                appDelegate?.saveContext()
                self.tableView.reloadData()
                
                return true
            })]
        }
        else if direction == .leftToRight{
            expansionSettings.fillOnTrigger = true
            expansionSettings.expansionColor = UIColor.init(red: 0, green: 34/255, blue: 74/255, alpha: 0.9)
            expansionSettings.threshold = 2
            print(check)
            return [MGSwipeButton(title:"Check/Uncheck", backgroundColor: UIColor.init(red: 151/255, green: 34/255, blue: 254/255, alpha: 1), callback: { (newcell:MGSwipeTableCell?) -> Bool in
                let cell = newcell as? ScheduleItemCell
                if self.checked == false{
                    self.checked = true
                    self.check = false
                    self.configureCheck(cell: cell!, check: self.checked)
                }else{
                     self.checked = false
                    self.check = true
                    self.configureCheck(cell: cell!, check: self.checked)
                   
                }

                return true
            })]

        }
        return []
    }
    
    
    //MARK: - INTERFACE BUILDER ACTIONS AND FUNCTIONS
    
    
    func configureCells(cell:ScheduleItemCell, indexPath:NSIndexPath){
        let scheduleItem = scheduleGroup.childSItems?[indexPath.row] as? SheduleItem
        cell.updateSItemUI(item: scheduleItem!)
    }
    
    func configureCheck(cell:ScheduleItemCell, check:Bool){
        cell.configureCheck(checked: check)
    }
    
    @IBAction func addScheduleItemButtonPressed(_ sender: AnyObject) {

        performSegue(withIdentifier: SEGUE_ADD_SCHEDULE_ITEM, sender:scheduleGroup)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == SEGUE_ADD_SCHEDULE_ITEM{
            if let destination = segue.destination as? AddScheduleItemVC{
                if let image = sender as? SheduleGroup{
                    destination.group = image
                }
            }
        }
        else if segue.identifier == SEGUE_SCHEDULE_ITEM_DETAILS{
            if let destination = segue.destination as? AddScheduleItemVC{
                if let itemToEdit = sender as? SheduleItem{
                    destination.sheduleItemToEdit = itemToEdit
                }
            }
        }
    }
    
    func name(check:Bool)->String{
        let name = check ? "Check" : "Uncheck"
        return name
    }
    
    func generatedata(){
        let group = scheduleGroup
        let items = group?.childSItems!.mutableCopy() as! NSMutableOrderedSet
        let item = SheduleItem(context: context!)
        item.sIName = "Doggie"
        
        let item1 = SheduleItem(context: context!)
        item1.sIName = "Doggie"
        let item2 = SheduleItem(context: context!)
        item2.sIName = "Doggie"
        let item3 = SheduleItem(context: context!)
        item3.sIName = "Doggie"
        let item4 = SheduleItem(context: context!)
        item4.sIName = "Doggie"
        
        items.add(item)
        items.add(item1)
        items.add(item2)
        items.add(item3)
        items.add(item4)
        group?.childSItems = items.copy() as? NSOrderedSet
    }
    

}
