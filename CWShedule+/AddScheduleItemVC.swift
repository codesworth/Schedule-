//
//  AddScheduleItemVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/22/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class AddScheduleItemVC: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var sItemImageView: UIImageView!
    @IBOutlet weak var sheduleItemTextfield: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var urgencySegment: UISegmentedControl!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var startDateView: UIView!

    @IBOutlet weak var addedNotesTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    var startTextFieldIsFirstResponder = false
    var accessoryValue:Int64! = 4
    var beginDate:Date!
    var endedDate:Date!
    var repeatArray = [String]()
    var group:SheduleGroup!
    var sheduleItemToEdit:SheduleItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blur(thisView: sItemImageView)
        tableView.delegate = self
        tableView.dataSource = self
        startDate.delegate = self
        endDate.delegate = self
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for:UIControlEvents.valueChanged )
        repeatArray = ["Hourly", "Daily", "Monthly", "Annually", "Never"]
        addedNotesTextView.layer.cornerRadius = 20
        
        guard sheduleItemToEdit == nil else{
            loadScheduleItemToEdit()
            self.title = "Schedule Details"
            return
        }
        sItemImageView.image = group.childSImages?.sImages as? UIImage
    }
    
    
    
    
    
    
    func datePickerValueChanged(datePicker:UIDatePicker){
        if startTextFieldIsFirstResponder{
            beginDate = datePicker.date
            startDate.text = beginDate.formatDate()
        }else{
            endedDate = datePicker.date
            endDate.text = endedDate.formatDate()
        }
    }
    

    
    
    @IBAction func saveItemButtonPressed(_ sender: AnyObject) {
        if endedDate != nil && beginDate != nil{
            let timeValidator = Int64(endedDate.timeIntervalSince(beginDate))
            if timeValidator > 0{
                if (sheduleItemTextfield.text?.characters.count)! > 2{
                    performSave()
                    _ = navigationController?.popViewController(animated: true)
                }
            }else{
                let alert = UIAlertController(title: "Wrong Date Choices", message: "The selected starting date is in the future relative to the ending date for the schedule. Please select a starting date that is in the past of the ending date or consider reversing date choices", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }else{
            if (sheduleItemTextfield.text?.characters.count)! > 2{
                performSave()
                _ = navigationController?.popViewController(animated: true)
            }

        }
        
    }

    
    func performSave(){
        var item: SheduleItem
        var urgency:ScheduleUrgency
        var details: ScheduleDetails
        if sheduleItemToEdit == nil{
             item = SheduleItem(context: context!)
            urgency = ScheduleUrgency(context: context!)
            details = ScheduleDetails(context: context!)
            
            if let itemTitle = sheduleItemTextfield.text, itemTitle != "" {
                
                item.sIName = itemTitle
                urgency.sUSetReminder = shouldRemindSwitch.isOn
                item.childSUrgency = urgency
                print(item.childSUrgency?.sUSetReminder)
                configUrgencySegment(item: item, urgency: urgency)
                print("the urgency is class :",item.childSUrgency?.sUUrgency)
                urgency.sURepeat = accessoryValue!
                item.childSUrgency = urgency
                //print("[\(item.childSUrgency?.sURepeat), \(accessoryValue)]")
                //print("to be repeated ", item.childSUrgency?.sURepeat)
                configureDuration(item: item)
                details.sDExtraDetails = addedNotesTextView.text
                item.childSDetails = details
                //print(item.childSDetails?.sDExtraDetails)
                let groups = group.childSItems?.mutableCopy() as! NSMutableOrderedSet
                groups.add(item)
                group.childSItems = groups.copy() as? NSOrderedSet
                appDelegate?.saveContext()
                print(item.childSDetails?.sDExtraDetails)
                print("the urgency is class :",(item.childSUrgency?.sUUrgency)!)
                print("to be repeated :",(item.childSUrgency?.sUSetReminder)!)
                print(item.childSUrgency?.sURepeat)
                print(item.childSUrgency?.sUSetReminder)
                print(item.childSUrgency?.sUUrgency)
                
            }

        }
        else{
            item = sheduleItemToEdit
            urgency = sheduleItemToEdit.childSUrgency!
            details = sheduleItemToEdit.childSDetails!
            
            item.sIName = sheduleItemTextfield.text
            urgency.sUSetReminder = shouldRemindSwitch.isOn
            item.childSUrgency = urgency
            print(item.childSUrgency?.sUSetReminder)
            configUrgencySegment(item: item, urgency: urgency)
            print("the urgency is class :",item.childSUrgency?.sUUrgency)
            urgency.sURepeat = accessoryValue!
            item.childSUrgency = urgency
            configureDuration(item: item)
            details.sDExtraDetails = addedNotesTextView.text
            item.childSDetails = details
            appDelegate?.saveContext()

        }
        
            }
    
    func configureDuration(item:SheduleItem){
        
        if beginDate != nil  {
            item.sIBeginDate = beginDate as NSDate
    
        }else{
            item.sIBeginDate = nil
        }
        
        if  endedDate != nil {
            item.sIEndDate = endedDate as NSDate

        }else{
            item.sIEndDate = nil
        }
        

        if beginDate != nil && endedDate != nil{
            item.sItemDuration = "\(beginDate.dateFormat()) -\(endedDate.dateFormat())"
        }
        else if beginDate != nil && endedDate == nil{
            item.sItemDuration = "Starting  \(beginDate.dateFormat())"
        }
        else if beginDate == nil && endedDate != nil{
            item.sItemDuration = "Ending  \(endedDate.dateFormat())"
        }
        else{
            item.sItemDuration = "No Duration Set"
        }
    }
    
    func configUrgencySegment(item:SheduleItem, urgency:ScheduleUrgency){
        if urgencySegment.selectedSegmentIndex == 0{
            urgency.sUUrgency = 1
            item.childSUrgency = urgency
        }else if urgencySegment.selectedSegmentIndex == 1{
            urgency.sUUrgency = 2
            item.childSUrgency = urgency
        }else if urgencySegment.selectedSegmentIndex == 2{
            urgency.sUUrgency = 3
            item.childSUrgency = urgency
        }
        print(urgency.sUUrgency)
        appDelegate?.saveContext()
        
    }
    
    
    func loadScheduleItemToEdit(){
        if let item = sheduleItemToEdit{
            sheduleItemTextfield.text = item.sIName
            shouldRemindSwitch.isOn = (item.childSUrgency?.sUSetReminder)!
            urgencySegment.selectedSegmentIndex = Int((item.childSUrgency?.sUUrgency)! - 1)
            repeatButton.setTitle(repeatArray[Int((item.childSUrgency?.sURepeat)!)], for: .normal)
            addedNotesTextView.text = item.childSDetails?.sDExtraDetails
            startDate.text = (item.sIBeginDate as? Date)?.formatDate()
            endDate.text = (item.sIEndDate as? Date)?.formatDate()
            print(item.childSUrgency?.sUUrgency)
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startDate{
            startDate.inputView = datePicker
            startTextFieldIsFirstResponder = true
        }else{
            endDate.inputView = datePicker
            startTextFieldIsFirstResponder = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    @IBAction func repeatButtonPressed(_ sender: AnyObject) {
        datePicker.removeFromSuperview()
        tableView.frame = CGRect(x: -100, y: -100, width: 250, height:250)
        tableView.layer.shadowRadius = 6.0
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        tableView.layer.shadowOpacity = 0.8
        tableView.layer.cornerRadius = 10.0
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: [], animations: {
            self.tableView.center = self.view.center
            self.view.addSubview(self.tableView)
            }, completion: nil)
    }

}






extension AddScheduleItemVC{
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatArray.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repeatOption = repeatArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDENTIFIER_REPEAT_CELL, for: indexPath) as? RepeatCells{
            cell.configureCell(arrayObject: repeatOption)
            return cell
        }
        return RepeatCells()
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? RepeatCells
        cell?.accessoryType = .checkmark
        accessoryValue = Int64(indexPath.row)
        
        repeatButton.setTitle(repeatArray[indexPath.row], for: .normal)
        UIView.animate(withDuration: 1, delay: 0, options: [.transitionCrossDissolve], animations: { 
            self.tableView.removeFromSuperview()
            }) { (Bool) in
                cell?.accessoryType = .none
        }
    
        
    }
    
    
    
}



extension Date{
    func dateFormat()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E HH:mm"
        return dateFormatter.string(from: self)
    }
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let formattedDate = dateFormatter.string(from:self)
        return formattedDate
    }
}
