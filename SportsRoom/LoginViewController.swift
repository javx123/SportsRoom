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
            displayAlert(title: "Missing information.", message: "Please provide both email and password.")
        } else {
            Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    print("Login Success!")
                    self.performSegue(withIdentifier: "toMain", sender: self)
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if emailTxtField.text == "" || passwordTxtField.text == "" {
            displayAlert(title: "Missing information.", message: "Please provide both email and password.")
        } else {
            
            Auth.auth().createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    let ref = Database.database().reference().child("users").child(user!.uid)
                    let key = "email"
                    let text = self.emailTxtField.text
                    ref.updateChildValues([key:text!])
                    print("Register Success!")
                    self.performSegue(withIdentifier: "toMain", sender: self)
                }
            }
        }
    }
    
    func displayAlert (title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
