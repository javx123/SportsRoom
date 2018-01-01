//
//  HostGameViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseMessaging
import DropDown


class HostGameViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var gameTitleTextField: UITextField!
    @IBOutlet weak var pickDateView: UIView!
    @IBOutlet weak var pickDateLabel: UILabel!
    @IBOutlet weak var pickLocationView: UIView!
    @IBOutlet weak var pickLocationLabel: UILabel!
    @IBOutlet weak var skillLevelControl: UISegmentedControl!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var numberOfPlayersSlider: UISlider!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var selectSportView: UIView!
    @IBOutlet weak var dropDownSelectionLabel: UILabel!
    @IBOutlet weak var otherSportTextField: UITextField!
    
    var address = String()
    var longitude = Double()
    var latitude = Double()
    var dateString = String()
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectSportView.layer.cornerRadius = 5
        pickDateView.layer.cornerRadius = 5
        pickLocationView.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        numberOfPlayersLabel.text = "1"
        dropDown.anchorView = selectSportView
        dropDown.dataSource = ["Baseball", "Basketball", "Hockey", "Soccer", "Football", "Tennis", "Softball", "Badminton", "Table Tennis", "Ball Hockey", "Ultimate", "Other"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        self.otherSportTextField.delegate = self
        
        let font = UIFont.systemFont(ofSize: 11.5)
        skillLevelControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                 for: .normal)
        
        otherSportTextField.isHidden = true
        
        gameTitleTextField.delegate = self
        costTextField.delegate = self
        notesTextField.delegate = self
        otherSportTextField.delegate = self
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !gameTitleTextField.isFirstResponder {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dropDown.selectionAction = { (index: Int, item: String) in
            self.dropDownSelectionLabel.textColor = UIColor.black
            self.dropDownSelectionLabel.text = item
            if item == "Other" {
                self.otherSportTextField.isHidden = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if otherSportTextField.isFirstResponder {
        self.dropDownSelectionLabel.text = self.otherSportTextField.text
        self.otherSportTextField.text = ""
        self.otherSportTextField.isHidden = true
        self.otherSportTextField.resignFirstResponder()
        }
        if gameTitleTextField.isFirstResponder {
        self.gameTitleTextField.resignFirstResponder()
        }
        if costTextField.isFirstResponder {
        self.costTextField.resignFirstResponder()
        }
        if notesTextField.isFirstResponder {
        self.notesTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func unwindFromMap (sender: UIStoryboardSegue) {
        if sender.source is SetLocationViewController {
            if let senderVC = sender.source as? SetLocationViewController {
                address = senderVC.addressString
                longitude = senderVC.longitudeDouble
                latitude = senderVC.latitudeDouble
                pickLocationLabel.textColor = UIColor.black
                pickLocationLabel.text = address
            }
            self.reloadInputViews()
        }
    }
    
    @IBAction func unwindFromDateSelector (sender: UIStoryboardSegue) {
        if sender.source is SelectDateViewController {
            if let senderVC = sender.source as? SelectDateViewController {
                pickDateLabel.textColor = UIColor.black
                dateString = senderVC.dateString
                pickDateLabel.text = dateString
            }
            self.reloadInputViews()
        }
    }
    
    @IBAction func sportSelectionTapped(_ sender: Any) {
        dropDown.show()
    }
    
    
    @IBAction func screenTapped(_ sender: Any) {
        gameTitleTextField.resignFirstResponder()
        costTextField.resignFirstResponder()
        notesTextField.resignFirstResponder()
        otherSportTextField.resignFirstResponder()
    }
    
    @IBAction func gamePosted(_ sender: Any) {
        // userID is equal to the current user's ID
        let userID = Auth.auth().currentUser?.uid
        
        let dateString = pickDateLabel.text
        
        // convert the segmented control value to a string
        let skillLevelString = skillLevelControl.titleForSegment(at: skillLevelControl.selectedSegmentIndex)
        
        if gameTitleTextField.text! == "" || dropDownSelectionLabel.text == "Select Sport" || pickLocationLabel.text == "Location" || pickDateLabel.text == "Date/Time" {
            StaticFunctions.displayAlert(title: "Missing information.", message: "Some information is missing. Please check that all fields have been filled out", uiviewcontroller: self)
            
        } else {
            if costTextField.text == "" {
                costTextField.text = "Free"
            }
            postGame(withUserID: userID!, title: gameTitleTextField.text!, sport: dropDownSelectionLabel.text!.lowercased(), date:dateString!, address: pickLocationLabel.text!, longitude:longitude, latitude:latitude, cost: costTextField.text!, skillLevel: skillLevelString!, numberOfPlayers: numberOfPlayersSlider.value, note: notesTextField.text!)
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func sliderChanged(_ sender: Any) {
        (sender as AnyObject).setValue(Float(lroundf(numberOfPlayersSlider.value)), animated: true)
        let sliderValue: Float = numberOfPlayersSlider.value
        let sliderNSNumber = sliderValue as NSNumber
        let playerString:String = sliderNSNumber.stringValue
        numberOfPlayersLabel.text = playerString
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "setLocation", sender: self)
    }
    
    func postGame(withUserID userID: String, title: String, sport: String, date: String, address: String, longitude: Double, latitude: Double, cost: String, skillLevel: String, numberOfPlayers: Float, note: String) {
        // create a game object
        let ref = Database.database().reference().child("games").childByAutoId()
        let gameIDkey = "gameID"
        let hostIDKey = "hostID"
        let titleKey = "title"
        let sportKey = "sport"
        let dateKey = "date"
        let locationKey = "address"
        let longitudeKey = "longitude"
        let latitudeKey = "latitude"
        let costKey = "cost"
        let skillKey = "skillLevel"
        let playerNumberKey = "numberOfPlayers"
        let noteKey = "notes"
        ref.updateChildValues([hostIDKey:userID,gameIDkey:ref.key,titleKey:title,sportKey:sport,dateKey:date,longitudeKey:longitude, latitudeKey:latitude,locationKey:address,costKey:cost,skillKey:skillLevel,playerNumberKey:numberOfPlayers,noteKey:note])
        
        // assign the game id to the current user's 'hosted games' list
        let userID = Auth.auth().currentUser?.uid
        let gameKey = ref.key
        let refUser = Database.database().reference().child("users").child(userID!).child("hostedGames")
        let hostedgamesKey = gameKey
        refUser.updateChildValues([hostedgamesKey:"true"])
        
        let MessagingTopic = "Message"
        Messaging.messaging().subscribe(toTopic: "/topics/\(gameKey)\(MessagingTopic)")
        
    }
    
    @IBAction func dateTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "SelectDateViewController") as UIViewController
        
        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
        pvc.transitioningDelegate = self
        
        self.present(pvc, animated: true, completion: nil)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController:presented, presenting: presenting)
    }
    
    
}
class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: (containerView!.bounds.height/3)*2, width: containerView!.bounds.width, height: containerView!.bounds.height/3)
    }
    
    
    
    
}


