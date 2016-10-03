//
//  ScheduleGroupDetail.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/21/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData

class ScheduleGroupDetail: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    var scheduleGroupToEdit:SheduleGroup!
    var imagePicker:UIImagePickerController!
    @IBOutlet weak var sGImageView: UIImageView!
    @IBOutlet weak var sGNameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sGImageView.contentMode = .scaleAspectFill
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        guard scheduleGroupToEdit == nil else {
            loadSheduleGroupToEdit()
            return
        }
        appDelegate?.saveContext()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }

    @IBAction func saveButtonPressed(_ sender:AnyObject){
        let picture = ScheduleImages(context: context!)
        picture.sImages = sGImageView.image
        
        var scheduleGroup:SheduleGroup
        
        if scheduleGroupToEdit == nil{
            scheduleGroup = SheduleGroup(context: context!)
        }else{
            scheduleGroup = scheduleGroupToEdit
        }
        
        if let name = sGNameTextfield.text, name != ""{
            scheduleGroup.sGName = name
        }
        scheduleGroup.childSImages = picture
        appDelegate?.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func sgGroupImageButtonSelectorPressed(_ sender: AnyObject) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Choose Image", style: .default) { (UIAlertAction) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action3 = UIAlertAction(title: "Take Photo", style: .default) { (UIAlertAction) in
            //Implement phototaking
        }
        
        let action4 = UIAlertAction(title: "Delete Photo", style: .destructive) { (UIAlertAction) in
            //Remove currnt photo
        }

        actionSheet.addAction(action2)
        actionSheet.addAction(action1)
        actionSheet.addAction(action3)
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
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    
    }
    
}
