//
//  GoupSelectionVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/28/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData


let REUSE_ID_GP_CELL = "GroupCell"
let NOTIF_GROUP_SELECTED = "GroupAdded"
class GoupSelectionVC: UITableViewController,NSFetchedResultsControllerDelegate {

    

    var scheduleItem:SheduleItem!
    var isFromCal:Bool!
    var fetchedResultsController:NSFetchedResultsController<SheduleGroup>!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Schedule Groups"
        tableView.estimatedRowHeight = 60
        tryFetch()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    func tryFetch(){
        
        
        let fetchRequest:NSFetchRequest<SheduleGroup> = SheduleGroup.fetchRequest()
        let dateSorting = NSSortDescriptor(key: "sGcreatedDate", ascending: false)
        
        fetchRequest.sortDescriptors = [dateSorting]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch let error as NSError{
            print("Eror occurred here with Signature: ", error.debugDescription)
        }
    }

    
    func configureCell(cell:UITableViewCell,group:SheduleGroup){
        let label = cell.viewWithTag(100) as! UILabel
        label.text = group.sGName
        let label2 = cell.viewWithTag(1001) as! UILabel
        let count = group.childSItems!.count
        if count == 1{
            label2.text = "One schedule"
        }else if count == 0{
            label2.text = "No schedules"
        }
        else{
            label2.text = "\(count) schedules"
        }
        let image = cell.viewWithTag(1002) as! UIImageView
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.image = group.childSImages?.sImages as? UIImage
    }
    func configureCheckMark(cell:UITableViewCell, group:SheduleGroup){
        if scheduleItem != nil && scheduleItem.childSGroup != nil{
            if group == scheduleItem.childSGroup!{
                cell.accessoryType = .checkmark
            }
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return (fetchedResultsController.sections?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = fetchedResultsController.sections?[section]
        let numberOfObjects = section?.numberOfObjects
        return numberOfObjects!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        let group = fetchedResultsController.object(at: indexPath)
        configureCell(cell: cell, group: group)
        configureCheckMark(cell: cell, group: group)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = fetchedResultsController.object(at: indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        if scheduleItem != nil{
            
            scheduleItem.childSGroup = group
            CoreDataStack.saveContext()
            cell?.accessoryType = .checkmark
            _ = navigationController?.popViewController(animated: true)
        }else{
            let dict = ["Group": group]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIF_GROUP_SELECTED), object: nil, userInfo: dict)
            cell?.accessoryType = .checkmark
            _ = navigationController?.popViewController(animated: true)
        }
        /*let groups = group.childSItems?.mutableCopy() as! NSMutableOrderedSet
        groups.add(item)
        group.childSItems = groups.copy() as? NSOrderedSet*/
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
