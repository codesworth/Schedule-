//
//  SettingsVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/24/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//


import UIKit
import QuartzCore
import MessageUI
import CoreData

let _KEY_USE_TOUCHID__ = "touchID"
let _KEY_USE_VOICE_SCHEDULES = "voiceShedules"
class SettingsVC: UIViewController , MFMailComposeViewControllerDelegate{
    
    //let maskLayer:CAShapeLayer = NavigationLogo.awakeLogoLayer()
    @IBOutlet weak var topcon1: NSLayoutConstraint!
    @IBOutlet weak var topCon: NSLayoutConstraint!
    @IBOutlet weak var sgNsIDeleteSwitch: UIView?
    @IBOutlet weak var enablePasscodeSwitch: UISwitch!
    
    @IBOutlet weak var topcon2: NSLayoutConstraint!
    @IBOutlet weak var resetstats: UIButton!
    @IBOutlet weak var autoCompleteremove: UIView!
    @IBOutlet weak var deletewithgroupSwitch: UISwitch!
    @IBOutlet weak var helperLabel: UILabel!
    @IBOutlet var helperView: UIView!
    @IBOutlet weak var removeCompletedAwitch: UISwitch!
    @IBOutlet weak var voiceSheduleEnablerSwitch: UISwitch!
    @IBOutlet weak var touchIDEnablerSwitch: UISwitch!
    
    @IBOutlet weak var sep: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        resolveDeviceLayoutSizes()
    }
    
    func resolveDeviceLayoutSizes(){
        let d = UIDevice.current.__deviceType
        switch d {
        case .iPhone5S:
            topCon.constant = 10
            topcon1.constant = 10
            topcon2.constant = 1
            sep.constant = 5
            break
        case .iPhone5:
            topCon.constant = 10
            topcon1.constant = 10
            topcon2.constant = 1
            sep.constant = 5
            break
        case .iPhone5C:
            topCon.constant = 10
            topcon1.constant = 10
            topcon2.constant = 1
            sep.constant = 5
            break
        case .iPhoneSE:
            topCon.constant = 10
            topcon1.constant = 10
            topcon2.constant = 1
            sep.constant = 5
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        enablePasscodeSwitch.setOn(UserDefaults.standard.bool(forKey: __APP_SECURED__), animated: true)
        touchIDEnablerSwitch.setOn(UserDefaults.standard.bool(forKey: _KEY_USE_TOUCHID__), animated: true)
        if !enablePasscodeSwitch.isOn{
            touchIDEnablerSwitch.isEnabled = false
        }else{
            touchIDEnablerSwitch.isEnabled = true
        }
        voiceSheduleEnablerSwitch.setOn(UserDefaults.standard.bool(forKey: _KEY_USE_VOICE_SCHEDULES), animated: true)
        removeCompletedAwitch.setOn(UserDefaults.standard.bool(forKey: KEY_AUTODELETECOMPLETE_), animated: true)
        deletewithgroupSwitch.setOn(UserDefaults.standard.bool(forKey: KEY_SCHDSG_AUTODELETE_), animated: true)
        
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        view.layer.mask = nil
    }
    
    func sendMail(){
        let name = UIDevice.current.name
        let system = UIDevice.current.systemName; let v = UIDevice.current.systemVersion
        let m = UIDevice.current.model
        let draftbody = "\(name) \(m) \(system)\(v)"
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([MAIL_CWSHPLUS])
        mailVC.setSubject("Codesworth Supprot")
        mailVC.setMessageBody(draftbody, isHTML: false)
        present(mailVC, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func review(_ sender: Any) {
        sendMail()
    }
    @IBAction func passcodeStateChanged(_ sender: UISwitch) {

        if sender.isOn{
            
            UserDefaults.standard.set(sender.isOn, forKey: _LOCK_STATE__)
            performSegue(withIdentifier: __STORY_ID_PASCODE__, sender: self)

        }else{
            UserDefaults.standard.set(sender.isOn, forKey: _LOCK_STATE__)
            performSegue(withIdentifier: __STORY_ID_PASCODE__, sender: self)
            touchIDEnablerSwitch.isOn = false
            UserDefaults.standard.set(touchIDEnablerSwitch.isOn, forKey: _KEY_USE_TOUCHID__)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == __STORY_ID_PASCODE__{
            if let vc = segue.destination as? PasscodeVC{
                vc.passcodeset = true
            }
        }
    }
    @IBAction func EnableVoiceScheduleChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: _KEY_USE_VOICE_SCHEDULES)
    }
    @IBAction func enableTouchIDchanged(_ sender:UISwitch){
        UserDefaults.standard.set(sender.isOn, forKey: _KEY_USE_TOUCHID__)
    }
    
    
    @IBAction func deleteSchedulesWithGroup(_ sender:UISwitch) {
        
        if sender.isOn{
            //var on = false
            let alert = UIAlertController(title: "Warning", message: "All schedules will be deleted when its containing schedule group is deleted", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .default){ a in sender.setOn(false, animated: true)}
            let action2 = UIAlertAction(title: "OK", style: .destructive) { (a) in
                UserDefaults.standard.set(sender.isOn, forKey: KEY_SCHDSG_AUTODELETE_)
            }
            alert.addAction(action); alert.addAction(action2)
            self.present(alert, animated: true, completion: {})
            
        }else{
           UserDefaults.standard.set(sender.isOn, forKey: KEY_SCHDSG_AUTODELETE_)
        }
        
    }
    
    @IBAction func removeCompleted(_ sender: UISwitch) {
        
        if sender.isOn{
            //var on = false
            let alert = UIAlertController(title: "Warning", message: "This will automatically remove a completed schedule from your list of schedules. A removed schedule cannot be recovered", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .default){ a in sender.setOn(false, animated: true)}
            let action2 = UIAlertAction(title: "OK", style: .destructive) { (a) in
                UserDefaults.standard.set(sender.isOn, forKey: KEY_AUTODELETECOMPLETE_)
            }
            alert.addAction(action); alert.addAction(action2)
            self.present(alert, animated: true, completion: {

            })
            
        }else{
            UserDefaults.standard.set(sender.isOn, forKey: KEY_AUTODELETECOMPLETE_)
        }
    
    }
    
    @IBAction func viewTuts(_ sender: Any) {
      let v = storyboard?.instantiateViewController(withIdentifier: "tutsVC") as? TutsVC
        v!.dismissible = true
        present(v!, animated: true, completion: nil)
    }
    
    @IBAction func contactUs(_ sender: Any) {
        sendMail()
    }
    
    @IBAction func aboutUs(_ sender: Any) {
        let url = URL(string: "http://www.codesworth.net")
        UIApplication.shared.open(url!, options: [:]) { (success) in}
    }
    
    @IBAction func ResetStatistics(_ sender: Any) {
        warn()
        
    }
    
    func warn(){
        let alert = UIAlertController(title: "Warning", message: "You are attempting to delete all your schedule data. This action cannot be undone", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default){ a in }
        let action2 = UIAlertAction(title: "OK", style: .destructive) { (a) in
            let reaction = UIAlertController(title: "Warning", message: "You are about to delete all schedule data from this iPhone.This action cannot be undone", preferredStyle: .actionSheet)
            let act = UIAlertAction(title: "Wipe All Data", style: .destructive, handler: { (a) in
                self.wipeCoreData()
            })
            let canc = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            reaction.addAction(act)
            reaction.addAction(canc)
            DispatchQueue.main.async {
                self.present(reaction, animated: true, completion: nil)
            }
        }
        alert.addAction(action); alert.addAction(action2)
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func wipeCoreData(){
        let g = NSFetchRequest<NSFetchRequestResult>(entityName: "SheduleGroup")
        let i = NSFetchRequest<NSFetchRequestResult>(entityName: "SheduleItem")
        let img = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleImages")
        let u = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleUrgency")
        let d = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleDetails")
        let core_delete = [g,img,i,u,d]
        for item in core_delete {
            let request = NSBatchDeleteRequest(fetchRequest: item)
            _ = try? context.execute(request)
        }
        NotificationCenter.default.post(.init(name: Notification.Name(rawValue: "Wiped")))
    }
    
}



extension UIViewController{
    
}
