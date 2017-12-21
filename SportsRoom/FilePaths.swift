//
//  FilePaths.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-21.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import Foundation
import Firebase

let userID = Auth.auth().currentUser?.uid

let refUserJoined = Database.database().reference().child("users").child(userID!).child("joinedGames")
let refUserHosted = Database.database().reference().child("users").child(userID!).child("hostedGames")


//let refGameJoined = Database.database().reference().child("games").child(gameKey).child("joinedPlayers")


