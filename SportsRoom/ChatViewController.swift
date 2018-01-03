//
//  ChatViewController.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-24.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseMessaging

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageArray = [Message]()
    var currentGame : Game!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveMessage()
        tableView.tableFooterView = UIView()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        messageTxtField.endEditing(true)
        messageTxtField.isEnabled = false
        let ref = Database.database().reference().child("games").child(currentGame.gameID).child("chatroom").childByAutoId()

        ref.updateChildValues(["email": Auth.auth().currentUser!.email!, "messageBody": messageTxtField.text!, "senderName": Auth.auth().currentUser!.displayName!, "timestamp": ServerValue.timestamp(), "senderID": Auth.auth().currentUser!.uid]) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Message saved!!!")
                self.messageTxtField.isEnabled = true
                self.messageTxtField.text = ""
            }
        }
    }
    
    func retrieveMessage() {
        let ref = Database.database().reference().child("games").child(currentGame.gameID).child("chatroom")
        ref.observe(.childAdded) { (snapshot) in
            let message = Message(snapshot: snapshot)
            self.messageArray.append(message)
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func screenTapped(_ sender: Any) {
        self.messageTxtField.resignFirstResponder()
    }
 
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        if let cell = cell as? ChatTableViewCell {
            let currentMessage = messageArray[indexPath.row]
            cell.senderLbl.text = currentMessage.senderName
            cell.messageLbl.text = currentMessage.messageBody
            cell.timestampLbl.text = currentMessage.timestamp
            self.tableView.separatorStyle = .none

//            let imageView = UIImageView(frame: CGRect(x: 10, y: 20, width: cell.frame.width-10, height: cell.frame.height-10))
//            cell.backgroundView = UIView()
//            cell.backgroundView!.addSubview(imageView)
            
            if currentMessage.senderID != Auth.auth().currentUser!.uid {
                cell.senderLbl.textColor = UIColor.black
//                imageView.image = UIImage(named: "chatReceived")
            } else {
//                imageView.image = UIImage(named: "chatSent")
            }
        }
        return cell
    }
  }
