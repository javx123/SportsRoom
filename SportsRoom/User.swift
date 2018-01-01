
//  User.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-20.
//  Copyright © 2017 Javier Xing. All rights reserved.


import UIKit
import FirebaseDatabase

class User: NSObject {
    var name: String = ""
    var email: String = ""
    var age: String = ""
    var bio: String = ""
    var profileImageURLString: String = ""
    var hostedGame: Dictionary <String, String>?
    var joinedGame: Dictionary <String, String>?
    var hostedGameArray: [String]?
    var joinedGameArray: [String]?
    var settings: [String: Any]?
    
    init(snapshot: DataSnapshot) {
        let gameDict = snapshot.value as! [String:Any]
        self.name = gameDict["name"] as? String ?? ""
        self.email = gameDict["email"] as? String ?? ""
        self.age = gameDict["age"] as? String ?? ""
        self.bio = gameDict["bios"] as? String ?? ""
        self.profileImageURLString = gameDict["profilePicture"] as? String ?? ""
        self.hostedGame = gameDict["hostedGames"] as? Dictionary <String, String> ?? [:]
        self.hostedGameArray = Array(hostedGame!.keys)
        self.joinedGame = gameDict["joinedGames"] as? Dictionary <String, String> ?? [:]
        self.joinedGameArray = Array(joinedGame!.keys)
        self.settings = gameDict["settings"] as? [String: Any]
}

}
