//
//  PasscodeVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/23/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import LocalAuthentication
var PASSCODE__ = "passcode"
var __APP_SECURED__ = "secured"
var _APP_WILLRESIGN_ACTIVE_STATE = false

class PasscodeVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var passcodeField: UITextField!
    @IBOutlet weak var touchIDButton:UIButton!
    let __key_bag = KeychainWrapper()
    var passcodeset:Bool  = false
    var lockIsEnabled:Bool!
    var newpasscode:String!
    var __secureContext = LAContext()
    var warningLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeField.tintColor = UIColor.clear
        warningLabel = view.viewWithTag(1003) as! UILabel
        warningLabel.text = "Enter Passcode"
        passcodeField.delegate = self
        passcodeField.keyboardType = .numberPad
        passcodeField.keyboardAppearance = .dark
        let touchAccesibility = UserDefaults.standard.bool(forKey: _KEY_USE_TOUCHID__)
        if !touchAccesibility{
            touchIDButton.isHidden = true
           
        }


        
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.characters.count == 4{
           validatePasscode(string: textField.text!)
        }else if appDelegate?.u_int_act_count == 2{
            self.view.endEditing(true)
        }
        appDelegate?.u_int_act_count += 1
    }
    
    func validatePasscode(string:String){
        let passcode = __key_bag.myObject(forKey: kSecValueData) as! String
        if (string) == passcode{
            performSegue(withIdentifier: "validated", sender: nil)

            appDelegate?.window?.makeKeyAndVisible()
        }else{
            animateWarningLabel()
            self.passcodeField.becomeFirstResponder()
            self.passcodeField.text = ""
        }
    }
    
    func textFieldDidChange(textfield:UITextField){
        if textfield.text?.characters.count == 4 {
            validatePasscode(string: textfield.text!)
        }
    }
    
    
    @IBAction func touchIDEngaged(_ sender: UIButton) {
        touchIDProcess()
    }
}


extension PasscodeVC{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaults.standard.bool(forKey: _KEY_USE_TOUCHID__) == false{
            touchIDButton.isHidden = true
        }
        if passcodeset == false{
        passcodeField.addTarget(self, action: #selector(textFieldDidChange(textfield:)), for: .editingChanged)
        }
        lockIsEnabled = UserDefaults.standard.bool(forKey: _LOCK_STATE__)
        if lockIsEnabled == false && passcodeset == true {
            navigationItem.title = "Enter Passcode"
            passcodeField.addTarget(self, action: #selector(validateForLockRemoval(textfield:)), for: .editingChanged)
        }
        
        if lockIsEnabled == true && passcodeset == true{
            navigationItem.title = "Enter A Passcode"
            passcodeField.addTarget(self, action: #selector(createAndSetPasscode(textField:)), for: .editingChanged)
        }
    }
    
    func validateForLockRemoval(textfield:UITextField){
        if textfield.text?.characters.count == 4{
            let passcode = __key_bag.myObject(forKey: kSecValueData) as! String
            if (textfield.text!) == passcode{
                UserDefaults.standard.set(false, forKey: __APP_SECURED__)
                passcodeField.endEditing(true)
                passcodeField.resignFirstResponder()
                _ = navigationController?.popViewController(animated: true)
            }else{
                animateWarningLabel()
                self.passcodeField.text = ""
            }
        }
    }
    
    func createAndSetPasscode(textField:UITextField){
        let passcode = textField.text!
        if passcode.characters.count == 4{
            newpasscode = passcode
            textField.text = ""
            //navigationItem.title = "Re-Enter New Passcode"
            warningLabel.text = "Re-Enter New Passcode"
            passcodeField.removeTarget(self, action: nil, for: .editingChanged)
            passcodeField.addTarget(self, action: #selector(validatedNewPasscode(textfield:)), for: .editingChanged)
        }
    }
    @objc private func validatedNewPasscode(textfield:UITextField){
        if textfield.text?.characters.count == 4{
            if textfield.text! == newpasscode{
                __key_bag.mySetObject(newpasscode, forKey: kSecValueData)
                __key_bag.writeToKeychain()
                UserDefaults.standard.set(true, forKey: __APP_SECURED__)
                _ = navigationController?.popViewController(animated: true)
            }else{
                animateWarningLabel()
                createAlert(title: "Wrong Passcode match", actionTitle: "OK", message: "Please make sure you re-enter the correct passcode initially selected", controller: self, actionStyle: .default, onComplete: {
                    self.passcodeField.text = ""
                    self.passcodeField.removeTarget(self, action: nil, for: .editingDidEnd)
                    self.passcodeField.addTarget(self, action: #selector(self.createAndSetPasscode(textField:)), for: .editingChanged)
                })
            }
        }
    }
    func animateWarningLabel(){
        warningLabel.text = "Wrong Password"
        warningLabel.textColor = UIColor.red
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: [], animations: {
            self.warningLabel.center.x += 40
        }) { (Bool) in
            
        }
    }
}


//MARK LOCAL_AUTHENTICATION

extension PasscodeVC{
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        passcodeField.becomeFirstResponder()

        
    }
    
    func setWillResignActive(){
        _APP_WILLRESIGN_ACTIVE_STATE = true
    }
    
    func unSetAppWillResignActive(){
        _APP_WILLRESIGN_ACTIVE_STATE = false
    }
    
    
    func touchIDProcess(){
        let touchAccesibility = UserDefaults.standard.bool(forKey: _KEY_USE_TOUCHID__)
        if touchAccesibility && !_APP_WILLRESIGN_ACTIVE_STATE{
            
            if __secureContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil){
                
                __secureContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authentication with Touch ID", reply: { (success:Bool, error:Error?) in
                    DispatchQueue.main.async {
                        if success{

                            appDelegate?.window?.makeKeyAndVisible()
                            
                        }
                        if error != nil{
                            var message:String
                            let title = "Error Authenticating"
                            let actionTitle = "Dismiss"
                            let style = UIAlertActionStyle.default
                            switch(error!) {
                            case LAError.authenticationFailed:
                                message = "There was a problem verifying your identity."
                                createAlert(title: title, actionTitle: actionTitle, message: message, controller: self, actionStyle: style, onComplete: {})
                                break;
                            case LAError.userCancel:
                                message = "You pressed cancel."
                                createAlert(title: title, actionTitle: actionTitle, message: message, controller: self, actionStyle: style, onComplete: {})
                                break;
                            case LAError.userFallback:
                                message = "You pressed password."
                                createAlert(title: title, actionTitle: actionTitle, message: message, controller: self, actionStyle: style, onComplete: {})
                                break;
                            default:
                                message = "Touch ID may not be configured"
                                createAlert(title: title, actionTitle: actionTitle, message: message, controller: self, actionStyle: style, onComplete: {})
                                break;
                            }
                        }else{
                            self.passcodeField.becomeFirstResponder()
                        }
                    }
                })
            }else{
                createAlert(title: "TouchID Unavailable", actionTitle: "Dismiss", message: "Your device does not have touchID capability", controller: self, actionStyle: .default, onComplete: {})
            }
        }
    }
}
