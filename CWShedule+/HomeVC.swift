 //
//  HomeVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/2/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//


import UIKit
import CoreData
import Speech




let speech = "Meeting on Today at 5:30"


class HomeVC: UIViewController, UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,SFSpeechRecognizerDelegate {
    
    
    var fetchedResultsController:NSFetchedResultsController<SheduleItem>!
    
    @IBOutlet weak var recordOverlay: UIImageView!
    @IBOutlet var dueTodayView: UIView!
    @IBOutlet weak var dueToday: UILabel!
    @IBOutlet weak var overdue: UILabel!
    @IBOutlet weak var speechTextView: UILabel!
    @IBOutlet var speechView: UIView!
    
    @IBOutlet weak var instructinfoView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var settingsbutton: UIBarButtonItem!
    @IBOutlet weak var overdueView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var completedView: UIView!
    @IBOutlet var completionView: UIView!
    @IBOutlet weak var completedPercentage: UILabel!
    @IBOutlet weak var completed: UILabel!
    var speechRecognizer = CWSpeechToText.speechService.speechRecognizer
    @IBOutlet weak var addScheduleButton: UIButton!
    @IBOutlet weak var instructionInfoButton:UIButton!
    var did = false
    var label:UILabel?
    var upComingSchedules:[SheduleItem]!
    var fetchRequest:NSFetchRequest<NSFetchRequestResult>!
    var finalText:String!
    var info:Dictionary<String,AnyObject>!
    var canSave = false
    var longTapGesture:UILongPressGestureRecognizer?
    var isRecordRotating = false
    var shouldStopRotating = false
    var settingShouldUnrotate = false
    var timer: Timer!
    var settingTimer:Timer!
    var anim_o = 0
    var index = 0
    var instructible = true
    var isgesturing = false
    var headerlabel:UILabel!
    var isSettingRotating = false
    var settingIsAnimating = false
    var recordIsAnimating = false
    var shouldInstruct = true
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        speechRecognizer?.delegate = self
        CWSpeechToText.speechService.speechRecognize(recordButton: recordButton)
        tryFetching()
        headerlabel = speechView.viewWithTag(110) as? UILabel
        recordButton.layer.cornerRadius = 45
         longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(performGestureSelector))
        longTapGesture?.minimumPressDuration = CFTimeInterval(exactly: 1.10)!
        addScheduleButton.addGestureRecognizer(longTapGesture!)
        NotificationCenter.default.addObserver(self, selector: #selector(notifSegue(notif:)), name:NSNotification.Name(rawValue: "Reschedule") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(awakeFromContextToday), name: NSNotification.Name(rawValue: "open"), object: nil)
        addScheduleButton.imageView?.contentMode = .scaleAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(d), name: NSNotification.Name("Wiped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(performGestureSelector), name: NSNotification.Name("Voice"), object: nil)
        initLabel()
        startAnimation()                                                                                          

    }
    
    func d(){
        tryFetching()
        tableView.reloadData()
    }
    
    func initLabel(){
        label = UILabel()
        label?.frame.size = CGSize(width: 300, height: 80)
        label?.center.x = self.view.center.x
        label?.center.y = self.view.frame.height + 20
        label?.textAlignment = .center
        label?.numberOfLines = 4
        label?.textColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CWScheduleStats.mainStats.resetStatisticData()
        tableView.reloadData()
        completedView.alpha = 0
        dueTodayView.alpha = 0
        CWScheduleStats.mainStats.computeStatistics()
        dueToday.text = "\(CWScheduleStats.mainStats.dueToday)"
        overdue.text = "\(CWScheduleStats.mainStats.overdue)"
        completed.text = "\(CWScheduleStats.mainStats.completed)"
        completedPercentage.text = "\(Int(CWScheduleStats.mainStats.completionPercentage))%"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (CWSharedAccess.shared.cwSharedDefaults?.bool(forKey: "canOpen"))!{
            CWSharedAccess.shared.cwSharedDefaults?.set(false, forKey: "canOpen")
        }
        if (appDelegate?.voicable)!{
            voiceScheduling()
            appDelegate?.voicable = false
        }
        
    }
    
    func notifSegue(notif:Notification){
        let item = notif.userInfo?["item"] as! SheduleItem
        self.performSegue(withIdentifier: SEGUE_UPCOMING_ITEM_DETAILS, sender: item)
    }
    var speechIsVisible = false
    func performGestureSelector(longTapgesture:UILongPressGestureRecognizer){
        if !shouldInstruct{instructionInfoButton.isEnabled = true}
        if longTapgesture.state == .ended{beginInstructionWithAnimation(); rotateSettings()}
            let canUseVoiceScheduling = UserDefaults.standard.bool(forKey: _KEY_USE_VOICE_SCHEDULES)
            if canUseVoiceScheduling{
                speechIsVisible = true
                speechView.layer.opacity = 1.0
                speechView.frame = UIScreen.main.bounds
                speechView.bounds = self.view.bounds
                view.addSubview(self.speechView)
                
                
            }else{
                createAlert(title: "Voice Scheduling Disabled", actionTitle: "OK", message: "Voice scheduling is disabled. Please enable voice scheduling in the apps settings  to use this feature.", controller: self, actionStyle: .default, onComplete: {})
            }
        
    }
    
    func beginInstructionWithAnimation(){
        if shouldInstruct{
            let instruction = instructions[index]
            if instructible {
                instructionInfoButton.isEnabled = false
                label?.text = instruction
                speechView.addSubview(label!)
                UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: [.curveEaseIn], animations: {
                    self.label?.frame.origin.y = self.speechTextView.center.y + 50
                    
                }) { (bool) in
                    UIView.animate(withDuration: 2, delay: 2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.curveEaseInOut], animations: {
                        self.label?.center.y -= 200
                        self.label?.alpha = 0
                        
                    }, completion: { (b) in
                        self.resetIntruction()
                        self.index += 1
                        if self.index > (instructions.count - 1){
                            self.index = 0
                            self.beginInstructionWithAnimation()
                        }else{
                            self.beginInstructionWithAnimation()
                        }
                    })
                }
                
            }
        }
        
    }
    
    func resetIntruction(){
            self.label?.center.y = self.view.frame.height + 20
        label?.removeFromSuperview()
        label?.alpha = 1
    }
    
    func fetch(){
        let date = NSDate()
        let predicate = NSPredicate(format: "sIBeginDate >= %@", date)
        let model = context.persistentStoreCoordinator!.managedObjectModel
        fetchRequest = (model.fetchRequestTemplate(forName: "fetchRequest"))!.copy() as? NSFetchRequest
        fetchRequest.predicate = predicate
        do{
            upComingSchedules = try context.fetch(fetchRequest) as? [SheduleItem]
            tableView.reloadData()
        }catch let error as NSError{
            print("Error with signature: ", error)
        }
        
    }
    
    
    func tryFetching(){
        let fetchRequest:NSFetchRequest<SheduleItem> = SheduleItem.fetchRequest()
        let dateSorting = NSSortDescriptor(key: "sIBeginDate", ascending: true)
        let date = NSDate()
        let predicate = NSPredicate(format: "sIBeginDate >= %@", date)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [dateSorting]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
        }else if segue.identifier == _SEGUE_ID_HOME_ALL_SCHEDULE_{
            isFromHomeVC = true
        }else{
            isFromHomeVC = true
        }
    }
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let item = upComingSchedules[indexPath.row]
        let item = fetchedResultsController.object(at: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: RE_USE_IDENTIFIER_UPCOMING_CELL, for: indexPath) as? UpcomingCells{
            cell.updateUpcoming(item: item)
            return cell
        }else{
            return UpcomingCells()
        }
    }
    
    func rotateSettings(){
        settingIsAnimating = true
        if self.isSettingRotating == false {
            
            self.settingsButton.rotate360Degrees(1, completionDelegate: nil)
            // Perhaps start a process which will refresh the UI...
            self.settingTimer = Timer(duration: 1, completionHandler: {
                self.rotateSettings()
                
            })
            self.settingTimer.start()
            //self.isSettingRotating = true
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: AnyObject){
       self.performSegue(withIdentifier: "Settings", sender: nil)
    }
    
    
    
    @IBAction func calendarButtonTapped(_ sender: AnyObject) {
    
        performSegue(withIdentifier: _SEGUE_ID_HOME_CALENDAR_, sender: nil)
    }
    
    @IBAction func allSchedulebuttonTapped(_ sender: AnyObject) {
        
        performSegue(withIdentifier: _SEGUE_ID_HOME_ALL_SCHEDULE_, sender: nil)
    }
 
    @IBAction func instructInfo(_ sender:UIButton){
        shouldInstruct = true
        instructible = true
        index = 0
       beginInstructionWithAnimation()
    }
    func recordRotate(){

        
        if self.isRecordRotating == false {
            
            self.recordOverlay.rotate360Degrees(1, completionDelegate: self)
            self.timer = Timer(duration: 2, completionHandler: {
                
            })

        }
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        
        instructible = false
        self.resetIntruction()
        instructionInfoButton.isEnabled = true
        self.anim_o = 1
        headerlabel.text = "Recording....."
        headerlabel.textColor = UIColor.red
        if !recordIsAnimating{recordRotate(); settingTimer.stop()}
        if canSave{
            addschedule(itemInfo: info)
            canSave = false
            self.finalText = nil
            speechView.removeFromSuperview()
            tableView.reloadData()
            speechTextView.text = ""
            self.headerlabel.text = ""
            self.shouldStopRotating = true
            
            recordButton.setImage(UIImage(named:"m"), for: .normal)

        }
        else{
            CWSpeechToText.speechService.microphoneTapped(recordButton: sender, textView: speechTextView) {
                

                self.finalText = CWSpeechToText.speechService.speechToText
                guard self.finalText == nil else{
                    self.info = TranscriptionService.mainService.starttranscripting(voiceText: self.finalText)
                    if !(self.info["snNsgA"] as! [String]).isEmpty{
                        let sn = self.info["snNsgA"] as! Array<String>
                        self.speechTextView.text = "Schedule: \(sn[0]) in schedule Group: \(sn[1])"
                        
                    self.shouldStopRotating = true
                    self.isRecordRotating = false
                        self.recordButton.setImage(UIImage(named:"s"), for: .normal)
                    self.headerlabel.textColor = UIColor.white
                    self.headerlabel.text = "Save Schedule"
                    self.canSave = true
                    }
                    return
                }
                self.headerlabel.text = ""
                self.speechTextView.text = "Sorry, I couldn't make out your words, please repeat."
                self.shouldStopRotating = true
                self.isRecordRotating = false
            
            }
            //self.shouldStopRotating = true
            //settingShouldUnrotate = false
        }
        
    }
    //MARK:- SPeech
    
    @IBAction func dismisSpeechButtonPressed(_ sender: AnyObject) {
        speechView.removeFromSuperview()
        speechIsVisible = false
        canSave = false
        speechTextView.text = nil
        settingTimer.stop()
        label?.removeFromSuperview()
        self.headerlabel.text = ""
        self.shouldInstruct = false
        recordButton.setImage(UIImage(named:"m"), for: .normal)

        
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
                let cell = tableView.cellForRow(at: indexPath) as? UpcomingCells
                configureCell(cell: cell!, indexPath: indexPath)
            }
            break
        }
        
    }

}



extension HomeVC{
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections.count
        }
        return 0
        //return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let secions = fetchedResultsController.sections
        let rows = secions?[section]
        //dueToday.text = "\(rows!.numberOfObjects)"
        if (rows?.numberOfObjects)! < 10{
            return (rows?.numberOfObjects)!
        }else{
            return 10
        }
        
        //return upComingSchedules.count
    }
    

    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: SEGUE_UPCOMING_ITEM_DETAILS, sender: item)
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
    
    func addschedule(itemInfo:Dictionary<String,AnyObject>){
        let s_id = itemInfo["snNsgA"] as! Array<String>
        let date = itemInfo["date"] as? Date
        let name = s_id[0]
        let groupname = s_id[1]
        let group:SheduleGroup
        let item = SheduleItem(context: context)
        let urgency = ScheduleUrgency(context: context)
        let details = ScheduleDetails(context: context)
        details.sDExtraDetails = ""
        item.sIName = name
        if date != nil{
            item.sIBeginDate = date! as NSDate
            item.sItemDuration = "Starting  \(date!.dateFormat())"
            item.childSUrgency?.sUSetReminder = true
        }else{item.sItemDuration = DURATION_SCHEDULE_ITEM__DEFAULT}
    
        
        urgency.sURepeat = 5
        urgency.sUUrgency = 1
        urgency.sUSetReminder = false
        item.childSDetails = details
        item.childSUrgency = urgency
        let fetchedgroups = CoreService.service.fetchScheduleGroup(name: groupname)
        if fetchedgroups.count == 0{
            group = SheduleGroup(context: context)
            group.sGName = s_id[1]
            let images = ScheduleImages(context: context)
            images.sImages = UIImage(named:"tech")
            group.childSImages = images
        }else{
           group = fetchedgroups[0]!
        }
        item.childSGroup = group
        group.addToChildSItems(item)

        CoreDataStack.saveContext()
        ScheduleNotifications.notification.shouldScheduleNotification(item: item)
        
        
    }
   

     func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if speechIsVisible{
            if !shouldStopRotating{
                recordRotate()
            }else{ isRecordRotating = true}
        
        }
            
    }
    
    func reset() {
    
        //self.isSettingRotating = false
         self.isRecordRotating = false
        self.shouldStopRotating = false
    }

    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        let reachability = Reachability.forInternetConnection()
        if recordButton.titleLabel?.text != "Save"{
            if reachability?.currentReachabilityStatus() == NetworkStatus.init(0){
                recordButton.isEnabled = false
                speechTextView.text = "No Active Internet Connection"
            }else{
                recordButton.isEnabled = true
                speechTextView.text = "" //__DIRECTIVE_VOICE_RECOG_SCHEDULE_AD__
            }
        }
    }
    
    func resetAnimations(){
        delay(seconds: 5) {
                UIView.animate(withDuration: 1, delay: 0, options: [.transitionCrossDissolve], animations: {
                    self.completionView.alpha = 1
                    self.completedView.alpha = 0
                    }, completion: nil)
                
                UIView.animate(withDuration: 1, delay: 3, options: [.transitionCrossDissolve, .transitionCurlDown], animations: {
                    self.overdueView.alpha = 1
                    self.dueTodayView.alpha = 0
                    }, completion: nil)
            self.startAnimation()
            }
    }
    
    func startAnimation(){
        delay(seconds: 5) {
            UIView.animate(withDuration: 1, delay: 0, options: [.transitionCrossDissolve], animations: {
                self.completionView.alpha = 0
                self.completedView.alpha = 1
                }, completion: { Void in
            })
            
            UIView.animate(withDuration: 1, delay: 2, options: [.transitionCrossDissolve, .transitionCurlDown], animations: {
                self.overdueView.alpha = 0
                self.dueTodayView.alpha = 1
                }, completion: { Void in
            })
           self.resetAnimations()
        }
    }
    
    func setInfogesture(){
        let info_tap = UITapGestureRecognizer(target: self, action: #selector(beginInstructionWithAnimation))
        info_tap.numberOfTapsRequired = 1
        instructinfoView.addGestureRecognizer(info_tap)
        
    }
}


extension HomeVC: UINavigationControllerDelegate,CAAnimationDelegate {
    
    func awakeFromContextToday(){
        if (CWSharedAccess.shared.cwSharedDefaults?.bool(forKey: "canOpen"))!{
            let id = CWSharedAccess.shared.cwSharedDefaults?.integer(forKey: "key")
            let item = CoreService.service.performFetchwith(itemID: Int64(id!))
            performSegue(withIdentifier: SEGUE_UPCOMING_ITEM_DETAILS, sender: item)
        }
    }
    
    func voiceScheduling(){
        
        rotateSettings()
        let canUseVoiceScheduling = UserDefaults.standard.bool(forKey: _KEY_USE_VOICE_SCHEDULES)
        if canUseVoiceScheduling{
            speechIsVisible = true
            speechView.layer.opacity = 1.0
            speechView.frame = UIScreen.main.bounds
            speechView.bounds = self.view.bounds
            view.addSubview(self.speechView)
            
            
        }else{
            createAlert(title: "Voice Scheduling Disabled", actionTitle: "OK", message: "Voice scheduling is disabled. Please enable voice scheduling in the apps settings  to use this feature.", controller: self, actionStyle: .default, onComplete: {})
        }
        
    }

    
}
 




