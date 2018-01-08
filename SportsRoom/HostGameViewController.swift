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
        
        gameTitleTextField.layer.borderColor = UIColor.white.cgColor
        gameTitleTextField.layer.borderWidth = 1
        gameTitleTextField.layer.cornerRadius = 7
        let titlePaddingView = UIView(frame: CGRect(x:0,y:0,width:10,height:gameTitleTextField.frame.height))
        gameTitleTextField.leftViewMode = UITextFieldViewMode.always
        gameTitleTextField.leftView = titlePaddingView
        
        selectSportView.layer.borderColor = UIColor.flatYellow.cgColor
        selectSportView.layer.borderWidth = 1
        selectSportView.layer.cornerRadius = 7
        
        otherSportTextField.layer.borderColor = UIColor.flatGrayDark.cgColor
        otherSportTextField.textColor = UIColor.flatGrayDark
        otherSportTextField.layer.borderWidth = 1
        otherSportTextField.layer.cornerRadius = 7
        let otherPaddingView = UIView(frame: CGRect(x:0,y:0,width:10,height:otherSportTextField.frame.height))
        otherSportTextField.leftViewMode = UITextFieldViewMode.always
        otherSportTextField.leftView = otherPaddingView
        
        pickDateView.layer.borderColor = UIColor.flatYellow.cgColor
        pickDateView.layer.borderWidth = 1
        pickDateView.layer.cornerRadius = 7
        
        pickLocationView.layer.borderColor = UIColor.flatYellow.cgColor
        pickLocationView.layer.borderWidth = 1
        pickLocationView.layer.cornerRadius = 7
        
        costTextField.layer.borderColor = UIColor.white.cgColor
        costTextField.layer.borderWidth = 1
        costTextField.layer.cornerRadius = 7
        let costPaddingView = UIView(frame: CGRect(x:0,y:0,width:10,height:costTextField.frame.height))
        costTextField.leftViewMode = UITextFieldViewMode.always
        costTextField.leftView = costPaddingView
        
        notesTextField.layer.borderColor = UIColor.white.cgColor
        notesTextField.layer.borderWidth = 1
        notesTextField.layer.cornerRadius = 7
        let notesPaddingView = UIView(frame: CGRect(x:0,y:0,width:10,height:notesTextField.frame.height))
        notesTextField.leftViewMode = UITextFieldViewMode.always
        notesTextField.leftView = notesPaddingView
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        numberOfPlayersLabel.text = "1"
        dropDown.anchorView = selectSportView
        dropDown.dataSource = ["Baseball", "Basketball", "Hockey", "Soccer", "Football", "Tennis", "Softball", "Table Tennis", "Squash", "Ultimate", "Rugby", "Other"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        self.otherSportTextField.delegate = self
        
        let font = UIFont.systemFont(ofSize: 10)
        skillLevelControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                 for: .normal)
        
        otherSportTextField.isEnabled = false
        gameTitleTextField.delegate = self
        costTextField.delegate = self
        notesTextField.delegate = self
        otherSportTextField.delegate = self
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !gameTitleTextField.isFirstResponder && !otherSportTextField.isFirstResponder{
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
            self.dropDownSelectionLabel.text = item
            if item == "Other" {
                self.otherSportTextField.isEnabled = true
                self.otherSportTextField.placeholder = "Enter Sport Name"
                self.otherSportTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
                self.otherSportTextField.layer.borderColor = UIColor.white.cgColor
                self.otherSportTextField.textColor = UIColor.white
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if otherSportTextField.isFirstResponder {
        self.dropDownSelectionLabel.text = otherSportTextField.text
        otherSportTextField.layer.borderColor = UIColor.flatGrayDark.cgColor
            self.otherSportTextField.setValue(UIColor.flatGrayDark, forKeyPath: "_placeholderLabel.textColor")

        otherSportTextField.text = ""
        otherSportTextField.placeholder = "Select 'Other' to enter a new sport"
        otherSportTextField.isEnabled = false
        otherSportTextField.resignFirstResponder()
        }
        if gameTitleTextField.isFirstResponder {
        gameTitleTextField.resignFirstResponder()
        }
        if costTextField.isFirstResponder {
        costTextField.resignFirstResponder()
        }
        if notesTextField.isFirstResponder {
        notesTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func unwindFromMap (sender: UIStoryboardSegue) {
        if sender.source is SetLocationViewController {
            if let senderVC = sender.source as? SetLocationViewController {
                address = senderVC.addressString
                longitude = senderVC.longitudeDouble
                latitude = senderVC.latitudeDouble
                pickLocationLabel.text = address
            }
            self.reloadInputViews()
        }
    }
    
    @IBAction func unwindFromDateSelector (sender: UIStoryboardSegue) {
        if sender.source is SelectDateViewController {
            if let senderVC = sender.source as? SelectDateViewController {
                dateString = senderVC.dateString
                if dateString == "" {
                    let currentDate = Date()
                    let dateFormatter = DateFormatter ()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .short
                    let noDateString = dateFormatter.string(from: currentDate)
                    pickDateLabel.text = noDateString
                } else {
                pickDateLabel.text = dateString
            }
            }
            self.reloadInputViews()
            if gameTitleTextField.isFirstResponder {
                gameTitleTextField.resignFirstResponder()
            }
            if costTextField.isFirstResponder {
                costTextField.resignFirstResponder()
            }
            if notesTextField.isFirstResponder {
                notesTextField.resignFirstResponder()
            }
            
        }
    }
    
    @IBAction func sportSelectionTapped(_ sender: Any) {
        dropDown.show()
        gameTitleTextField.resignFirstResponder()
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
            } else {
                if let text = costTextField.text {
                   costTextField.text = "$\(text)" }
            }
            if notesTextField.text == "" {
                notesTextField.text = "The organizer did not include a note"
            }
            postGame(withUserID: userID!, title: gameTitleTextField.text!, sport: dropDownSelectionLabel.text!.lowercased(), date:dateString!, address: pickLocationLabel.text!, longitude:longitude, latitude:latitude, cost: costTextField.text!, skillLevel: skillLevelString!, numberOfPlayers: numberOfPlayersSlider.value, note: notesTextField.text!, spotsRemaining: numberOfPlayersSlider.value)
            
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
    
    func postGame(withUserID userID: String, title: String, sport: String, date: String, address: String, longitude: Double, latitude: Double, cost: String, skillLevel: String, numberOfPlayers: Float, note: String, spotsRemaining: Float) {
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
        let spotsKey = "spotsRemaining"
        ref.updateChildValues([hostIDKey:userID,gameIDkey:ref.key,titleKey:title,sportKey:sport,dateKey:date,longitudeKey:longitude, latitudeKey:latitude,locationKey:address,costKey:cost,skillKey:skillLevel,playerNumberKey:numberOfPlayers,noteKey:note, spotsKey:spotsRemaining])
        
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


