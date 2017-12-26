//
//  Message.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-24.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Message: NSObject {
    
    var senderName = ""
    var senderID = ""
    var timestamp = ""
    var messageBody = ""
    
    init(snapshot: DataSnapshot) {
        let messageDict = snapshot.value as! [String:Any]
        self.senderID = messageDict ["senderID"] as? String ?? ""
        self.senderName = messageDict ["senderName"] as? String ?? ""
        self.timestamp = messageDict ["timestamp"] as? String ?? ""
        self.messageBody = messageDict ["messageBody"] as? String ?? ""
    }

    
    
    
}
