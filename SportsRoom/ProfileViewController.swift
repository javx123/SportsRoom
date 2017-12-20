//
//  ProfileViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var biosLbl: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    let keyEmail = "email"
    let keyName = "name"
    let keyAge = "age"
    let keyBios = "bios"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInfo()
        
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        if (editBtn.title(for: UIControlState.normal) == "Edit") {
            editBtn.setTitle("Save", for: UIControlState.normal)
            labelsState(hidden: true)
            fieldsState(hidden: false)
            nameTxtField.text = nameLbl.text
            ageTxtField.text = ageLbl.text
            bioTextView.text = biosLbl.text
        } else {
            editBtn.setTitle("Edit", for: UIControlState.normal)
            labelsState(hidden: false)
            fieldsState(hidden: true)
            editUserInfo()
            updateUserInfo()
            displayAlert(title: "Request completed", message: "User profile updated!")
        }
    }
    
    func labelsState (hidden:Bool) {
        nameLbl.isHidden = hidden
        ageLbl.isHidden = hidden
        biosLbl.isHidden = hidden
    }
    
    func fieldsState (hidden:Bool) {
        nameTxtField.isHidden = hidden
        ageTxtField.isHidden = hidden
        bioTextView.isHidden = hidden
        
    }
    
    func editUserInfo () {
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users").child(userID)
        let nameValue = nameTxtField.text ?? ""
        let biosValue = bioTextView.text ?? ""
        let ageValue = ageTxtField.text ?? ""
        ref.updateChildValues([keyName:nameValue, keyBios:biosValue, keyAge:ageValue])
    }
    
    func updateUserInfo () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value?[self.keyEmail] as? String ?? ""
            let name = value?[self.keyName] as? String ?? ""
            let bios = value?[self.keyBios] as? String ?? ""
            let age = value?[self.keyAge] as? String ?? ""
            self.emailLbl.text = email
            self.nameLbl.text = name
            self.biosLbl.text = bios
            self.ageLbl.text = age
        }
    }
    
    func displayAlert (title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

