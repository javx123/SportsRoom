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
import FirebaseStorage
import SDWebImage
import SVProgressHUD

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
    
    var currentUser: User?
    var imageString = String()
    var imageURL: URL!
    var imageData = Data ()
    var profileImage = UIImage ()
    
    let keyEmail = "email"
    let keyName = "name"
    let keyAge = "age"
    let keyBios = "bios"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInfo()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForImage()
        updateUserInfo()
    }

    func checkForImage () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!).child("profilePicture")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let snapshotValue = snapshot.value as? String
            if snapshotValue == nil {
                self.imageView.image = UIImage(named:"defaultimage")
            } else {
                self.imageView.sd_setImage(with: URL(string: snapshotValue!))
            }
    }
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
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nameTxtField.text
        changeRequest?.commitChanges { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func updateUserInfo () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            self.currentUser = User(snapshot: snapshot)
            self.emailLbl.text = self.currentUser?.email
            self.nameLbl.text = self.currentUser?.name
            self.biosLbl.text = self.currentUser?.bio
            self.ageLbl.text = self.currentUser?.age
            
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: picker.sourceType)
        picker.mediaTypes = mediaTypes ?? [String]()
        picker.delegate = self
        present(picker, animated: true, completion: {() -> Void in
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let userID = Auth.auth().currentUser?.uid
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageData = UIImagePNGRepresentation(image!)
        
        let photosRef = Storage.storage().reference().child("profilePhotos").child(userID!)
        let photoRef = photosRef.child("\(NSUUID().uuidString).png")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        photoRef.putData(imageData!, metadata: metadata).observe(.success) { (snapshot) in
        // When the image has successfully uploaded, we get it's download URL
        self.imageString = (snapshot.metadata?.downloadURL()?.absoluteString)!
        print (self.imageString)
        let ref = Database.database().reference().child("users").child(userID!)
        let profileKey = "profilePicture"
            ref.updateChildValues([profileKey:self.imageString])
        self.setimage()
        }
        self.dismiss(animated: true, completion: nil)
        SVProgressHUD.show(withStatus:"loading")
    }
    
    func setimage () {
        self.imageView.sd_setImage(with:URL(string:imageString)) { (image, error, type, url) in
            SVProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userSettings" {
            let userSettingsVC = segue.destination as? SettingsContainerViewController
            userSettingsVC?.currentUser = currentUser
        }
    }
    
    @IBAction func unwindFromSettings (sender: UIStoryboardSegue) {
        if sender.source is SettingsContainerViewController {
            if let senderVC = sender.source as? SettingsContainerViewController {
                let userID = Auth.auth().currentUser!.uid
                let ref = Database.database().reference().child("users").child(userID)
                
                let userSearchRadius = senderVC.userSettingsVC?.searchRadius
                //                write info to user in firebase
                
//                switch senderVC.filterOptions.selectedSegmentIndex {
//                case 0:
//                    //                    change filter in user info to date
//                    let defaultSettings: [String: Any] = ["radius": userSearchRadius,
//                                                          "filter": "date"]
//                    ref.updateChildValues(["settings" : defaultSettings])
//                case 1:
//                    //                    change filter in user info to location
//                    let defaultSettings: [String: Any] = ["radius": userSearchRadius,
//                                                          "filter": "distance"]
//                    ref.updateChildValues(["settings" : defaultSettings])
//                default:
//                    print("No matching segment")
//                }
                switch senderVC.userSettingsVC?.filterType {
                case .date?:
//                    change filter in user info to date
                    let defaultSettings: [String : Any] = ["radius": userSearchRadius, "filter": "date"]
                    ref.updateChildValues(["settings" : defaultSettings])
                case .distance?:
                    let defaultSettings: [String : Any] = ["radius" : userSearchRadius, "filter": "distance"]
                    ref.updateChildValues(["settings" : defaultSettings])
                case .none:
                    print("There's a bug if this is hit....")
                }
                
            }
        }
        
    }

    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("Signout Success!")
        }
        catch {
            print("error: there was a problem signing out")
        }
        self.performSegue(withIdentifier: "unwindToLoginVC", sender: self)
        
    }
}


