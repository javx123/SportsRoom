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

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
