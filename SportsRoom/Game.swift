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
    var joinedPlayers: Dictionary <String, String>
    var joinedPlayersArray = [String]()
    var allPlayersArray: [String] = []
    
//    var players = [String]
    
    init(snapshot: DataSnapshot) {
        let gameDict = snapshot.value as! [String:Any]
        self.address = gameDict["address"] as? String ?? ""
        self.latitude = gameDict["latitude"] as? Double ?? 0
        self.longitude = gameDict["longitude"] as? Double ?? 0
        self.cost = gameDict["cost"] as? String ?? ""
        self.date = gameDict["date"] as? String ?? ""
        self.hostID = gameDict["hostID"] as? String ?? ""
        self.notes = gameDict["notes"] as? String ?? ""
        self.numberOfPlayers = gameDict["numberOfPlayers"] as? Int ?? 0
        self.skillLevel = gameDict["skillLevel"] as? String ?? ""
        self.sport = gameDict["sport"] as? String ?? ""
        self.title = gameDict["title"] as? String ?? ""
        self.gameID = gameDict["gameID"] as? String ?? ""
        self.joinedPlayers = gameDict["joinedPlayers"] as? Dictionary <String, String> ?? [:]
        self.joinedPlayersArray = Array(joinedPlayers.keys)
        self.allPlayersArray = Array(joinedPlayersArray)
        self.allPlayersArray.append(hostID)
        


    }
    
    init(address: String, latitude: Double, longitude: Double, cost: String, date: String, hostID: String, notes: String, numberOfPlayers: Int, skillLevel: String, sport: String, title: String, gameID: String) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.cost = cost
        self.date = date
        self.hostID = hostID
        self.notes = notes
        self.numberOfPlayers = numberOfPlayers
        self.skillLevel = skillLevel
        self.sport = sport
        self.title = title
        self.gameID = gameID
        self.joinedPlayers = [:]
        self.joinedPlayersArray = []
        self.allPlayersArray = []
    }
}




