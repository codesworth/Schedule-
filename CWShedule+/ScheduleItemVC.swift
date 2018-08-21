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
    //var checked = false
    var check = true
    var fetchedResultsController:NSFetchedResultsController<SheduleItem>!
    var scheduleGroup:SheduleGroup!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = scheduleGroup.sGName
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        //sGImageView.image = scheduleGroup.childSImages?.sImages as? UIImage
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        if scheduleGroup.childSItems?.count == 0{
            view.bringSubview(toFront: sGImageView)
        }else{
            view.bringSubview(toFront: tableView)
            view.bringSubview(toFront: addSIButton)
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
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let item = scheduleGroup.childSItems?[indexPath.row] as! SheduleItem
        self.performSegue(withIdentifier: SEGUE_SCHEDULE_ITEM_DETAILS, sender: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath) as! ScheduleItemCell
        let item = scheduleGroup.childSItems?[indexPath.row] as! SheduleItem
        self.configCheck(item: item, cell: cell)
        if item.sItemChecked{
            let autoDeletable = UserDefaults.standard.bool(forKey: KEY_AUTODELETECOMPLETE_)
            if autoDeletable{deleteItemOnCheck(item: item)
                CoreDataStack.saveContext()
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.reloadData()

            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleItemCell
        let item = scheduleGroup.childSItems?[indexPath.row] as! SheduleItem
       configCheck(item: item, cell: cell)
        let autoDeletable = UserDefaults.standard.bool(forKey: KEY_AUTODELETECOMPLETE_)
        if autoDeletable{deleteItemOnCheck(item: item)
            CoreDataStack.saveContext()
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
            
        }


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
            //cell.accessoryType = .none
            expansionSettings.expansionColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.9)
            expansionSettings.threshold = 3
            
            return [ MGSwipeButton(title: "Delete", backgroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 1), callback: { (cell:MGSwipeTableCell?) -> Bool in
                let indexPath = self.tableView.indexPath(for: cell!)
                
                let item = self.scheduleGroup.childSItems?[(indexPath?.row)!] as? SheduleItem
                context.delete(item!)
                //self.tableView.deleteRows(at: [indexPath!], with: .right)
                CoreDataStack.saveContext()
                self.tableView.reloadData()
                
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
    
    func deleteItemOnCheck(item:SheduleItem){
        if item.sItemChecked{
            context.delete(item)
            
        }
    }
    
    private func configCheck(item:SheduleItem, cell:ScheduleItemCell){
        if item.sItemChecked{
            item.sItemChecked = false
            CoreDataStack.saveContext()
            cell.configureCheck(checked: false)
        }else{
            item.sItemChecked = true
            
            cell.configureCheck(checked: true)
            
            CoreDataStack.saveContext()
            
        }
    }
    
    
    

}
