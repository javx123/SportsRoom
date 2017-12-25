//
//  LoginViewController.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-18.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if emailTxtField.text == "" || passwordTxtField.text == "" {
            StaticFunctions.displayAlert(title: "Missing information.", message: "Please provide both email and password.", uiviewcontroller: self)
        } else {
            Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
                if error != nil {
                    StaticFunctions.displayAlert(title: "Error", message: error!.localizedDescription, uiviewcontroller: self)
                } else {
                    print("Login Success!")
                    self.performSegue(withIdentifier: "toMain", sender: self)
                }
            }
        }
    }
    

}
