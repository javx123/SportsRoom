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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        
        let defaults = UserDefaults.standard
        emailTxtField.text = defaults.string(forKey: "emailTextFieldContent")
        passwordTxtField.text = defaults.string(forKey: "passTextFieldContent")
        
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
        return true
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        emailTxtField.resignFirstResponder()
        passwordTxtField.resignFirstResponder()
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
                    UserDefaults.standard.set(self.emailTxtField.text, forKey: "emailTextFieldContent")
                    UserDefaults.standard.set(self.passwordTxtField.text, forKey: "passTextFieldContent")
                    self.performSegue(withIdentifier: "toMain", sender: self)
                }
            }
        }
    }
    

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

}
