//
//  SignUpViewController.swift
//  SportsRoom
//
//  Created by Daniel Grosman on 2017-12-25.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        ageTxtField.delegate = self
        nameTxtField.delegate = self
        
        nameTxtField.backgroundColor = UIColor.clear
        nameTxtField.layer.borderColor = UIColor.white.cgColor
        nameTxtField.layer.borderWidth = 1
        nameTxtField.layer.cornerRadius = 7
        nameTxtField.textColor = UIColor.white
        let namePaddingView = UIView(frame: CGRect(x:0,y:0,width:40,height:nameTxtField.frame.height))
        nameTxtField.leftViewMode = UITextFieldViewMode.always
        nameTxtField.leftView = namePaddingView
        
        ageTxtField.backgroundColor = UIColor.clear
        ageTxtField.layer.borderColor = UIColor.white.cgColor
        ageTxtField.layer.borderWidth = 1
        ageTxtField.layer.cornerRadius = 7
        ageTxtField.textColor = UIColor.white
        let agePaddingView = UIView(frame: CGRect(x:0,y:0,width:40,height:ageTxtField.frame.height))
        ageTxtField.leftViewMode = UITextFieldViewMode.always
        ageTxtField.leftView = agePaddingView
        
        emailTxtField.backgroundColor = UIColor.clear
        emailTxtField.layer.borderColor = UIColor.white.cgColor
        emailTxtField.layer.borderWidth = 1
        emailTxtField.layer.cornerRadius = 7
        emailTxtField.textColor = UIColor.white
        let emailPaddingView = UIView(frame: CGRect(x:0,y:0,width:40,height:emailTxtField.frame.height))
        emailTxtField.leftViewMode = UITextFieldViewMode.always
        emailTxtField.leftView = emailPaddingView
        
        passwordTxtField.backgroundColor = UIColor.clear
        passwordTxtField.layer.borderColor = UIColor.white.cgColor
        passwordTxtField.layer.borderWidth = 1
        passwordTxtField.layer.cornerRadius = 7
        passwordTxtField.textColor = UIColor.white
        let passPaddingView = UIView(frame: CGRect(x:0,y:0,width:40,height:passwordTxtField.frame.height))
        passwordTxtField.leftViewMode = UITextFieldViewMode.always
        passwordTxtField.leftView = passPaddingView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTxtField.resignFirstResponder()
        passwordTxtField.resignFirstResponder()
        ageTxtField.resignFirstResponder()
        nameTxtField.resignFirstResponder()
        return true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func screenTapped(_ sender: Any) {
       emailTxtField.resignFirstResponder()
        passwordTxtField.resignFirstResponder()
        ageTxtField.resignFirstResponder()
        nameTxtField.resignFirstResponder()
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if emailTxtField.text == "" || passwordTxtField.text == "" || nameTxtField.text == "" || ageTxtField.text == "" {
            StaticFunctions.displayAlert(title: "Missing information.", message: "Some information is missing. Please check that all fields have been filled out", uiviewcontroller: self)
        } else {
            Auth.auth().createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
                if error != nil {
                    StaticFunctions.displayAlert(title: "Error", message: error!.localizedDescription, uiviewcontroller: self)
                } else {
                    let ref = Database.database().reference().child("users").child(user!.uid)
                    let emailkey = "email"
                    let emailtext = self.emailTxtField.text?.lowercased()
                    let namekey = "name"
                    let nametext = self.nameTxtField.text
                    let agekey = "age"
                    let agetext = self.ageTxtField.text
                    let settingskey = "settings"
                    let defaultSettings: [String: Any] = ["radius": 30000,
                                                          "filter": "date"]
                    ref.updateChildValues([emailkey:emailtext!,namekey:nametext!,agekey:agetext!, settingskey: defaultSettings])
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.nameTxtField.text
                    changeRequest?.commitChanges { (error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    }
                    
                    print("Register Success!")
                    self.performSegue(withIdentifier: "signUpToMain", sender: self)
                }
            }
        }
    }
    
    
    
    
    
}
