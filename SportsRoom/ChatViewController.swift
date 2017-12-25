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
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        messageTxtField.endEditing(true)
        messageTxtField.isEnabled = false
//        sendBtn.isEnabled = false
//        let ref = Database.database().reference().child("games").child(currentGame.gameID).child("chatroom").childByAutoId()
        let ref = Database.database().reference().child("games").child("-L0v5d_PxtqiIU7GeZUi").child("chatroom").childByAutoId()
        ref.setValue(["sender": Auth.auth().currentUser?.email, "messageBody": messageTxtField.text]) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Message saved!!!")
                self.messageTxtField.isEnabled = true
//                self.sendBtn.isEnabled = true
                self.messageTxtField.text = ""
            }
        }   
    }
    
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell
        
        return cell!
    }
    
}
