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
    var email = ""
    var title = ""
    
    init(snapshot: DataSnapshot) {
        let messageDict = snapshot.value as! [String:Any]
        self.senderID = messageDict ["senderID"] as? String ?? ""
        self.senderName = messageDict ["senderName"] as? String ?? ""
        let timestampRaw = messageDict ["timestamp"] as? Double ?? 0
        let timeStampconverted = NSDate(timeIntervalSince1970: timestampRaw / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
//        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let time = dateFormatter.string(from: timeStampconverted as Date)
        self.timestamp = time
        self.messageBody = messageDict ["messageBody"] as? String ?? ""
        self.email = messageDict ["email"] as? String ?? ""
        self.title = messageDict ["title"] as? String ?? ""
    }

    
    
    
}
