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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageArray = [Message]()
    var currentGame : Game!

    
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveMessage()
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        messageTxtField.endEditing(true)
        messageTxtField.isEnabled = false
        let ref = Database.database().reference().child("games").child(currentGame.gameID).child("chatroom").childByAutoId()
//        let currentTime = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
//        let dateString = dateFormatter.string(from: currentTime)

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
        }
        return cell
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        self.messageTxtField.resignFirstResponder()
    }
    
    
}
