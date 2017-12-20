//
//  Games.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-20.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Games : NSObject {
    
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
    var cost = ""
    var date = ""
    var hostID = ""
    var notes = ""
    var numberOfPlayers = ""
    var skillLevel = ""
    var sport = ""
    var title = ""
    var gameID = ""
    
    init(snapshot: DataSnapshot) {
        
        let gameDict = snapshot.value as! [String:Any]
        self.address = gameDict["address"] as! String
        self.latitude = gameDict["latitude"] as! Double
        self.longitude = gameDict["longitude"] as! Double
        self.cost = gameDict["cost"] as! String
        self.date = gameDict["date"] as! String
        self.hostID = gameDict["hostID"] as! String
        self.notes = gameDict["notes"] as! String
        self.numberOfPlayers = gameDict["numberOfPlayers"] as! String
        self.skillLevel = gameDict["skillLevel"] as! String
        self.sport = gameDict["sport"] as! String
        self.title = gameDict["title"] as! String
        self.gameID = gameDict["gameID"] as! String
    }

}
