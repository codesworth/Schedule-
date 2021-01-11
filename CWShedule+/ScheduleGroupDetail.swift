//
//  ScheduleGroupDetail.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/21/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData

class ScheduleGroupDetail: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    var scheduleGroupToEdit:SheduleGroup!
    var imagePicker:UIImagePickerController!
    var imageshows = false
    @IBOutlet weak var sGImageView: UIImageView!
    @IBOutlet weak var sGNameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(boolSetter), name: NSNotification.Name(rawValue: "PicSet"), object: nil)
        sGImageView.contentMode = .scaleAspectFill
        sGNameTextfield.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if scheduleGroupToEdit != nil {
            loadSheduleGroupToEdit()
            
        }else{
            sGImageView.image = UIImage(named: imageGuesser())
        }
        
        CoreDataStack.saveContext()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func boolSetter(){
        imageshows = true
    }
    @IBAction func saveButtonPressed(_ sender:AnyObject){
        if sGNameTextfield.text?.characters.count != 0{
            if imageshows{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Added"), object: nil)
            }
            let picture = ScheduleImages(context: context)
            picture.sImages = sGImageView.image
            
            var scheduleGroup:SheduleGroup
            
            if scheduleGroupToEdit == nil{
                scheduleGroup = SheduleGroup(context: context)
            }else{
                scheduleGroup = scheduleGroupToEdit
            }
            
            if let name = sGNameTextfield.text, name != ""{
                scheduleGroup.sGName = name.capitalized
            }
            scheduleGroup.childSImages = picture
            CoreDataStack.saveContext()
            _ = navigationController?.popViewController(animated: true)
        }else{
            createAlert(title: "Group title", actionTitle: "Dismiss", message: "Please enter a schedule group name", controller: self, actionStyle: .default, onComplete: {})
        }
    }

    @IBAction func sgGroupImageButtonSelectorPressed(_ sender: AnyObject) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Choose Image", style: .default) { (UIAlertAction) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //let action3 = UIAlertAction(title: "Take Photo", style: .default) { (UIAlertAction) in
            //Implement phototaking
        //}
        
        let action4 = UIAlertAction(title: "Random", style: .default) { (UIAlertAction) in
            let s = self.imageGuesser()
            self.sGImageView.image = UIImage(named: s)
        }

        actionSheet.addAction(action2)
        actionSheet.addAction(action1)
        actionSheet.addAction(action4)
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            sGImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func loadSheduleGroupToEdit(){
        if let scheduleGroup = scheduleGroupToEdit{
            sGNameTextfield.text = scheduleGroup.sGName
            sGImageView.image = scheduleGroup.childSImages?.sImages as? UIImage
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func imageGuesser()->String{
        let list = ["architecture","boots", "calendar","work", "tech" ]
        let i = arc4random_uniform(UInt32(list.count))
        return list[Int(i)]
        
    }
    
}
