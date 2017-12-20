//
//  Game.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-20.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Game : NSObject {
    
    var address = ""
    var latitude : Double = 0
    var longitude : Double = 0
    var cost = ""
    var date = ""
    var hostID = ""
    var notes = ""
    var numberOfPlayers = 0
    var skillLevel = ""
    var sport = ""
    var title = ""
    var gameID = ""
    
    init(snapshot: DataSnapshot) {
        let gameDict = snapshot.value as! [String:Any]
        self.address = gameDict["address"] as? String ?? ""
        let coordinatesDict = gameDict["coordinates"] as! [String:Any]
        self.latitude = coordinatesDict["latitude"] as? Double ?? 0
        self.longitude = coordinatesDict["longitude"] as? Double ?? 0
        self.cost = gameDict["cost"] as? String ?? ""
        self.date = gameDict["date"] as? String ?? ""
        self.hostID = gameDict["hostID"] as? String ?? ""
        self.notes = gameDict["notes"] as? String ?? ""
        self.numberOfPlayers = gameDict["numberOfPlayers"] as? Int ?? 0
        self.skillLevel = gameDict["skillLevel"] as? String ?? ""
        self.sport = gameDict["sport"] as? String ?? ""
        self.title = gameDict["title"] as? String ?? ""
        self.gameID = gameDict["gameID"] as? String ?? ""
    }
}
