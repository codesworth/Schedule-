
//
//  AddScheduleItemVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/22/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class AddScheduleItemVC: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    //MARK: - IBOUTLETS
    @IBOutlet weak var repeatButton: UIButton!
    
    @IBOutlet weak var schedcon: NSLayoutConstraint!
    @IBOutlet weak var datecon: NSLayoutConstraint!
    @IBOutlet weak var notetopcon2: NSLayoutConstraint!
    @IBOutlet weak var notetopcon: NSLayoutConstraint!
    @IBOutlet weak var notesbotcon: NSLayoutConstraint!
    @IBOutlet weak var selectGroupButton: UIButton!
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
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackheight:NSLayoutConstraint!
    @IBOutlet weak var dateStackView: UIStackView!
    //MARK: - CLASS PROPERTIES
    
    @IBOutlet weak var groupview: UIView!
    var startTextFieldIsFirstResponder = false
    var accessoryValue:Int64!
    var beginDate:Date!
    var endedDate:Date!
    var repeatArray = [String]()
    var group:SheduleGroup?
    var sheduleItemToEdit:SheduleItem!
    var selectedDate:NSDate!
    var isFromCalView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blur(thisView: sItemImageView)
        tableView.delegate = self
        tableView.dataSource = self
        startDate.delegate = self
        endDate.delegate = self
        sheduleItemTextfield.delegate = self
        addedNotesTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(createAndHoldScheduleGroup(notification:)), name: NSNotification.Name(rawValue: NOTIF_GROUP_SELECTED), object: nil)
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        
        if isFromCalView && sheduleItemToEdit == nil{
            beginDate = selectedDate as Date!
            startDate.text = beginDate.formatDate()
            datePicker.setDate(selectedDate as Date!, animated: true)
        }
        if sheduleItemToEdit != nil{
            loadScheduleItemToEdit()
            self.title = "Schedule Details"
        }
        
        if group != nil || sheduleItemToEdit != nil{
            selectGroupButton.setTitle(group?.sGName! ?? sheduleItemToEdit.childSGroup?.sGName, for: .normal)
            selectGroupButton.tintColor = UIColor.black
        }
        
    }
    
    func createAndHoldScheduleGroup(notification:Notification){
        let new = notification.userInfo?["Group"] as! SheduleGroup
        group = new
    }
    
    
    func datePickerDonePressed(){

        view.endEditing(true)
    }
    
    func ended(){
        self.datecon.constant += 19
        self.schedcon.constant += 59
        view.endEditing(true)

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
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        self.datecon.constant -= 19
        self.schedcon.constant -= 59
        

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
             item = SheduleItem(context: context)
            urgency = ScheduleUrgency(context: context)
            details = ScheduleDetails(context: context)
            
            if let itemTitle = sheduleItemTextfield.text, itemTitle != "" {
                
                item.sIName = itemTitle.capitalized
                urgency.sUSetReminder = shouldRemindSwitch.isOn
                item.childSUrgency = urgency
                if accessoryValue == nil{
                    urgency.sURepeat = 5
                }else{
                    urgency.sURepeat = accessoryValue
                }
                configUrgencySegment(item: item, urgency: urgency)
                item.childSUrgency = urgency
                configureDuration(item: item)
                details.sDExtraDetails = addedNotesTextView.text
                item.childSDetails = details
                if group != nil{
                    let groups = group?.childSItems?.mutableCopy() as! NSMutableOrderedSet
                    groups.add(item)
                    group?.childSItems = groups.copy() as? NSOrderedSet
                }else{
                    
                }
                CoreDataStack.saveContext()
            }

        }
        else{
            item = sheduleItemToEdit
            urgency = sheduleItemToEdit.childSUrgency!
            details = sheduleItemToEdit.childSDetails!
            
            item.sIName = sheduleItemTextfield.text
            urgency.sUSetReminder = shouldRemindSwitch.isOn
            item.childSUrgency = urgency
            configUrgencySegment(item: item, urgency: urgency)
            urgency.sURepeat = accessoryValue!
            item.childSUrgency = urgency
            configureDuration(item: item)
            details.sDExtraDetails = addedNotesTextView.text
            item.childSDetails = details
            CoreDataStack.saveContext()

        }
        
            }
    
    
    func configureDuration(item:SheduleItem){
        
        if beginDate != nil  {
            item.sIBeginDate = beginDate as NSDate
            ScheduleNotifications.notification.shouldScheduleNotification(item: item)
            item.sCalenderID = "\(dateDayFormat(date: (self.beginDate)! as NSDate)) 00:00:00 +0000"
        }else{
            item.sIBeginDate = nil
            item.sCalenderID = ""
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
            item.sItemDuration = DURATION_SCHEDULE_ITEM__DEFAULT
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
        CoreDataStack.saveContext()
        
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
            beginDate = item.sIBeginDate as? Date
            endedDate = item.sIEndDate as? Date
            accessoryValue = sheduleItemToEdit.childSUrgency!.sURepeat
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
    func datePickerDoneConfig(){
        let layer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 240))
        layer.backgroundColor = UIColor.darkGray
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setTitle("Done", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(datePickerDonePressed), for: .touchUpInside)
        layer.addSubview(button)
        layer.addSubview(datePicker)
        view.addSubview(layer)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func repeatButtonPressed(_ sender: AnyObject) {
        view.endEditing(true)
        //datePicker.removeFromSuperview()
        repeatButton.isEnabled = false

        UIView.animate(withDuration: 0.3, animations: {
            self.dateStackView.frame.origin.y -= 200
            self.dateStackView.isHidden = true
            self.stackView.frame.origin.y -= 200
            self.tableView.frame.origin.y -= 200
            self.tableView.frame.size.height += 180
            
            }) { (Bool) in

        }

    }

    @IBAction func groupbuttonSelected(_ sender: UIButton) {
        performSegue(withIdentifier: SEGUE_TO_GROUP_SELECT_PAGE, sender: sheduleItemToEdit)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_TO_GROUP_SELECT_PAGE{
            if let vc = segue.destination as? GoupSelectionVC{
                if let item = sender as? SheduleItem{
                    vc.scheduleItem = item
                    vc.isFromCal = isFromCalView
                }
            }
        }
    }
}






extension AddScheduleItemVC {
    
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
        resetViews(title: repeatArray[indexPath.row])
    }
    
    @objc(tableView:didDeselectRowAtIndexPath:) func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? RepeatCells
        cell?.accessoryType = .none
    }
    
    func resetViews(title:String){
        UIView.animate(withDuration: 0.4, animations: { 
            self.dateStackView.frame.origin.y += 200
            self.dateStackView.isHidden = false
            self.stackView.frame.origin.y += 200
            self.tableView.frame.origin.y += 200
            self.tableView.frame.size.height -= 180

            }) { (Bool) in
                self.repeatButton.setTitle(title, for: .normal)
                self.repeatButton.isEnabled = true
        }
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
        
    }

    func configUI(){
        sheduleItemTextfield.keyboardAppearance = .dark
        addedNotesTextView.keyboardAppearance = .dark
        let toolbar = UIToolbar().ToolbarPiker(mySelect: #selector(datePickerDonePressed))
        let ntb = UIToolbar().ToolbarPiker(mySelect: #selector(ended))
        startDate.inputAccessoryView = toolbar
        endDate.inputAccessoryView = toolbar
        addedNotesTextView.inputAccessoryView = ntb
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for:UIControlEvents.valueChanged )
        repeatArray = ["Hourly", "Daily","Weekly", "Monthly", "Annually", "Never"]
        addedNotesTextView.layer.cornerRadius = 10

    }
}



extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
