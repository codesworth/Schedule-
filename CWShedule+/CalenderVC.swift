 //
//  CalenderVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/5/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData
 
 
 typealias ___CW__code_arc__Count__ = UInt64
 
class CalenderVC: UIViewController,JTCalendarDelegate,NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate {
    
    @IBOutlet weak var calenderView: JTHorizontalCalendarView!
    @IBOutlet weak var menuView: JTCalendarMenuView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dividingLineView: UIView!
    @IBOutlet weak var voiceButton:UIButton!
    var calenderManager:JTCalendarManager!
    var fetchedResultsController:NSFetchedResultsController<SheduleItem>!
    var dateSelected:NSDate!
    var canSwipeUp = true
    var canSwipeDown = false
    var calenderID:String!
    var dayID:[NSDate?] = []
    var destinationISHome = false
    var can_run = false
    var monthCount:Int!
    var selectedDate:NSDate!
    var monthlyItems:Array<SheduleItem?>!
    var string:String!
    var year:String!
    var delayBool = true
    var codeCounter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        navigationItem.hidesBackButton = true
        //codeCounter = 0
        fetchCalenderIDs()
//        monthNumber() = returnMonthNumber()
//        monthNumber() -= 1
        tableView.delegate = self
        tableView.dataSource = self
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipe.direction = .up
        view.addGestureRecognizer(swipe)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        dateSelected = NSDate()
        performFetch()
        calenderManager = JTCalendarManager()
        calenderManager.delegate = self
        calenderManager.contentView = calenderView
        calenderManager.menuView = menuView
        calenderManager.setDate(Date())
        tableView.reloadData()
        let _long__ = UILongPressGestureRecognizer(target: self, action: #selector(longpress))
        _long__.minimumPressDuration = 1
        voiceButton.addGestureRecognizer(_long__)
        
    }
    
    func longpress(){
        _ = navigationController?.popToRootViewController(animated: true)
        appDelegate?.voicable = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCalenderIDs()
        performFetch()
        tableView.reloadData()
        print("the string:", string)
        print("the year:", year)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        fetchedResultsController = nil
    }
    private func performFetch(){
        calenderID = "\(dateDayFormat(date: dateSelected)) 00:00:00 +0000"
        let fetchRequest:NSFetchRequest<SheduleItem> = SheduleItem.fetchRequest()
        let dateSort = NSSortDescriptor(key: "sIBeginDate", ascending: true)
        let predicate = NSPredicate(format: "sCalenderID == %@ ", calenderID)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [dateSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch let error as NSError{
            print("Terminated with error signature: ", error.debugDescription)
        }
        
    }
    
    func swipedUp(){
        if canSwipeUp{

            //populateCells()
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.calenderView.frame.origin.y += -300
                self.dividingLineView.frame.origin.y += -252
                self.tableView.frame.origin.y -= 240
                self.tableView.frame.size.height += self.calenderView.frame.size.height
                self.tableView.reloadData()
                }, completion: { (Bool) in
                    self.canSwipeUp = false
                    self.canSwipeDown = true
            })
        }
    }
    
    func swipedDown(){
        if canSwipeDown{

            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
                self.tableView.frame.size.height -= self.calenderView.frame.size.height
                self.tableView.frame.origin.y += 240
                self.dividingLineView.frame.origin.y += 252
                self.calenderView.frame.origin.y += 300
                
                }, completion: { Bool in
                    self.canSwipeUp = true
                    self.canSwipeDown = false
                    self.can_run = false
            })
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
                let cell = tableView.cellForRow(at: indexPath) as? CalenderCells
                ConfigureCell(cell: cell!, indexPath: indexPath)
            }
            break
        }

    }
    
    func ConfigureCell(cell:CalenderCells, indexPath:IndexPath){
        let item = fetchedResultsController.object(at: indexPath)

        cell.updateCalendarCellsUI(item: item)
        
    }

    //MARK: - JTCALENDAR DELEGATES IMPLEMENTATION
     var counter = 0
    var bool = false
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        let dayView = dayView as! JTCalendarDayView
        setCalID(date: dayView.date)

        codeCounter += 1

        if codeCounter == 1{
         tableView.reloadData()
            
        }else if codeCounter == 126{
            if canSwipeDown{
               populateCells()
                can_run = true
            }
            if can_run{
              tableView.reloadData()
            
            }
            codeCounter = 0
        }
        

        dayView.isHidden = false
        //dayView.layer.borderColor = UIColor.clear.cgColor
        if dayView.isFromAnotherMonth{
            dayView.isHidden = true
        }else if calenderManager.dateHelper.date(Date(), isTheSameDayThan: dayView.date){
            dayView.circleView.isHidden = false
            dayView.circleView.layer.borderColor = UIColor.clear.cgColor
            dayView.circleView.backgroundColor = UIColor.clear
            dayView.layer.borderWidth = 1.8
            dayView.layer.borderColor = UIColor.white.cgColor
            dayView.textLabel.textColor = UIColor.white
            
        }
        else if (dateSelected != nil) && calenderManager.dateHelper.date(dateSelected as Date!, isTheSameDayThan: ((dayView.date) as NSDate) as Date!){
            dayView.circleView.isHidden = false
            
            dayView.circleView.backgroundColor = UIColor.clear
            dayView.circleView.layer.borderColor = UIColor.white.cgColor
            //dayView.layer.borderWidth = 1.8
            
            dayView.textLabel.textColor = UIColor.white
        }else{
            dayView.circleView.isHidden = true
            dayView.textLabel.textColor = UIColor.white
            dayView.dashView.isHidden = true

            
        }
        for aDay in dayID{
            if calenderManager.dateHelper.date(aDay as Date!, isTheSameDayThan: dayView.date){
                dayView.dotView.isHidden = false
            }
        }
        
    }
    
    func getIDs(){
        
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        let dayView = dayView as! JTCalendarDayView
        dateSelected = setFormat(for: dayView.date) as NSDate!
        dayView.circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.transition(with: dayView.circleView, duration: 0.3, options: [], animations: {
            dayView.circleView.transform = CGAffineTransform.identity
            self.calenderManager.reload()
            }, completion:{ Bool in
                self.performFetch()
                self.tableView.reloadData()
        })
        //dayView.backgroundColor = UIColor.clear
        //dayView.layer.borderWidth = 1.8
        //dayView.layer.borderColor = UIColor.white.cgColor
        calenderManager.reload()
        
        
        if !(calenderManager.dateHelper.date(calenderView.date, isTheSameMonthThan: dayView.date)){
            if calenderView.date .compare(dayView.date) == .orderedAscending{
                calenderView.loadNextPageWithAnimation()
            }else{
                calenderView.loadPreviousPageWithAnimation()
            }
        }
        
    }
    
    @IBAction func homeButtonPressed(_ sender: AnyObject) {

        _ = navigationController?.popToRootViewController(animated: true)
    }

    
    @IBAction func allSchdeulesButtonPressed(_ sender: AnyObject) {
        

        performSegue(withIdentifier: SEGUE_CALL_ALL, sender: nil)
    }
    
    @IBAction func addSchedule(_ sender: Any) {
        performSegue(withIdentifier: SEGUE_CAL_TO_ADD, sender: nil)
    }
    
    
    func fetchCalenderIDs(){
        var calIDs = [SheduleItem]()
        let request:NSFetchRequest<SheduleItem> = SheduleItem.fetchRequest()

        do{
             calIDs = try context.fetch(request)
            
            for x in calIDs{
                let id = x.sIBeginDate
                dayID.append(id)
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
        
    }
    

}





extension CalenderVC{
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        if !can_run{
            if let section = fetchedResultsController.sections{
                return section.count
            }
            else{
                return 1
            }
        }
            return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if can_run{
            return monthlyItems.count
        }else{
            if let sections = fetchedResultsController.sections{
                let objects = sections[section]
                return objects.numberOfObjects
            }
        }
        return 0
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RE_USE_IDENTIFIER_CALENDAR_CELLS, for: indexPath) as! CalenderCells
        if !can_run{
           ConfigureCell(cell: cell, indexPath: indexPath)
        }else{
            let item = monthlyItems[indexPath.row]
            cell.updateCalendarCellsUI(item: item!)
            return cell
        }
        
        
        return cell
    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item:SheduleItem
        if !can_run{
          item = fetchedResultsController.object(at: indexPath)
        }else{
            item = monthlyItems[indexPath.row]!
        }
        performSegue(withIdentifier: SEGUE_CAL_TO_ADD, sender: item)
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeVC{
            destinationISHome = true
        }
        else if segue.identifier == SEGUE_CAL_TO_ADD{
            if let addVc = segue.destination as? AddScheduleItemVC{
                if sender != nil{
                    let item = sender as? SheduleItem
                    addVc.sheduleItemToEdit = item
                }else{
                    addVc.selectedDate = dateSelected
                    addVc.isFromCalView = true
                }

            }
        }
    }
    
    func monthNumber()->String{
        let dateformatter = DateFormatter()
        dateformatter.setLocalizedDateFormatFromTemplate("MM")
        let string = dateformatter.string(from: Date())
        let searchword = "2017-\(string)"
        return searchword
    }
    
    func populateCells(){
        if string == "01"{
            string  = "13"
            year = "\(Int(year)! - 1)"
        }
        var month = "\(Int(string)! - 1)"
        if month.characters.count == 1{
            month = "0\(month)"
        }
        let stringConstruct = "\(year!)-\(month)"
        
        monthlyItems = []
        monthlyItems = CoreService.service.performFetchFromSearch(string: stringConstruct, itemName: "sCalenderID")

        can_run = true
        tableView.reloadData()
    }
    
    func themonthNumber()->Int{
        let dateformatter = DateFormatter()
        dateformatter.setLocalizedDateFormatFromTemplate("MM")
        let string = dateformatter.string(from: Date())
        let numb = Int(string)
        if numb != nil{
            switch numb! {
            case 01:
                return 01
            case 02:
                return 02
            case 03:
                return 03
            
            case 04:
                return 04
            case 05:
                return 05
            case 06:
                return 06
            case 07:
                return 07
            case 08:
                return 08
            case 09:
                return 09
            case 10:
                return 10
            case 11:
                return 11
            case 12:
                return 12
            default:
                return 13
            }
        }else{
            return 0
        }
    }

    func setCalID(date:Date){
        let dateformatter = DateFormatter()
        dateformatter.setLocalizedDateFormatFromTemplate("MM")
        string = dateformatter.string(from:date)
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        year = format.string(from: date)
    }
    

    
}
