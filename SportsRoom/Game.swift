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
    
    var address: String = ""
    var latitude : Double = 0
    var longitude : Double = 0
    var cost = ""
    var date = ""
    var hostID = ""
    var notes = ""
    var spotsRemaining = 0
    var numberOfPlayers = 0
    var skillLevel = ""
    var sport = ""
    var title = ""
    var gameID = ""
    var joinedPlayers: Dictionary <String, String>?
    var joinedPlayersArray: [String]?
    var allPlayersArray = [String]()
    var distance: Int? 
    
//    var players = [String]
    
    init(snapshot: DataSnapshot) {
        let gameDic: [String:Any]? = snapshot.value as? [String:Any]
        guard let gameDict = gameDic else {return}
        
        self.address = gameDict["address"] as? String ?? ""
        self.latitude = gameDict["latitude"] as? Double ?? 0
        self.longitude = gameDict["longitude"] as? Double ?? 0
        self.cost = gameDict["cost"] as? String ?? ""
        self.date = gameDict["date"] as? String ?? ""
        self.hostID = gameDict["hostID"] as? String ?? ""
        self.notes = gameDict["notes"] as? String ?? ""
        self.numberOfPlayers = gameDict["numberOfPlayers"] as? Int ?? 0
        self.spotsRemaining = gameDict["spotsRemaining"] as? Int ?? 0
        self.skillLevel = gameDict["skillLevel"] as? String ?? ""
        self.sport = gameDict["sport"] as? String ?? ""
        self.title = gameDict["title"] as? String ?? ""
        self.gameID = gameDict["gameID"] as? String ?? ""
        self.joinedPlayers = gameDict["joinedPlayers"] as? Dictionary <String, String> ?? [:]
        self.joinedPlayersArray = Array(joinedPlayers!.keys)
        self.allPlayersArray = Array(joinedPlayersArray!)
        self.allPlayersArray.append(hostID)
        


    }
    
    init(gameInfo: Dictionary <String, Any>) {
        self.address = gameInfo["address"] as! String
        self.latitude = gameInfo["latitude"] as! Double
        self.longitude = gameInfo["longitude"] as! Double
        self.cost = gameInfo["cost"] as! String
        self.date = gameInfo["date"] as! String
        self.hostID = gameInfo["hostID"] as! String
        self.notes = gameInfo["notes"] as! String
        self.numberOfPlayers = gameInfo["numberOfPlayers"] as! Int
        self.spotsRemaining = gameInfo["spotsRemaining"] as! Int
        self.skillLevel = gameInfo["skillLevel"] as! String
        self.sport = gameInfo["sport"] as! String
        self.title = gameInfo["title"] as! String
        self.gameID = gameInfo["gameID"] as! String
        self.joinedPlayers = gameInfo["joinedPlayers"] as? Dictionary <String, String> ?? [:]
        self.joinedPlayersArray = Array(joinedPlayers!.keys)
        self.allPlayersArray = Array(joinedPlayersArray!)
        allPlayersArray.append(hostID)
    }
}




