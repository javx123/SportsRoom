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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var biosLbl: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
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
            StaticFunctions.displayAlert(title: "Request completed", message: "User profile updated!", uiviewcontroller: self)
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
            let currentUser = User(snapshot: snapshot)
            self.emailLbl.text = currentUser.email
            self.nameLbl.text = currentUser.name
            self.biosLbl.text = currentUser.bio
            self.ageLbl.text = currentUser.age

        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: picker.sourceType)
        picker.mediaTypes = mediaTypes ?? [String]()
        picker.delegate = self
        present(picker, animated: true, completion: {() -> Void in
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageData = UIImagePNGRepresentation(imageView.image!)
        guard let imageURL: NSURL = info[UIImagePickerControllerReferenceURL] as? NSURL else { return }
        
        let photosRef = storage.reference().child("profilePhotos")
        let photoRef = photosRef.child("\(NSUUID().UUIDString).png")

        dismiss(animated: true, completion: {() -> Void in
        })
    }
    
}

