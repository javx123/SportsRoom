//
//  DetailsViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    var currentGame: Game!
    
    enum ButtonState: String {
        case joined = "Leave Game"
        case hosted = "Cancel Game"
        case search = "Join Game"
    }
    
    @IBOutlet weak var gameActionBtn: UIButton!
    
    var btnText : ButtonState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonState(buttonState: btnText!)
        setLabels()
    }
    
    func setLabels(){
        gameTitleLabel.text = currentGame.title
        sportLabel.text = currentGame.sport
        dateLabel.text = currentGame.date
        locationLabel.text = currentGame.address
        skillLabel.text = currentGame.skillLevel
        costLabel.text = currentGame.cost
        notesLabel.text = currentGame.notes
    }
    
    func setButtonState(buttonState : ButtonState) {
        switch buttonState {
        case .joined:
            gameActionBtn.setTitle(ButtonState.joined.rawValue, for: UIControlState.normal)
            gameActionBtn.backgroundColor = UIColor.red
        case .hosted:
            gameActionBtn.setTitle(ButtonState.hosted.rawValue, for: UIControlState.normal)
            gameActionBtn.backgroundColor = UIColor.red
        case .search:
            gameActionBtn.setTitle(ButtonState.search.rawValue, for: UIControlState.normal)
            gameActionBtn.backgroundColor = UIColor.green
        }
    }
    
    //    Mark: - DataSource Properties
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        cell.textLabel?.text = "Player One"
        return cell
    }
    
    @IBAction func gameActionPressed(_ sender: UIButton) {
            switch btnText! {
            case .hosted:
                cancelGame()
            case .joined:
                leaveGame()
            case .search:
                joinGame()
        }
            dismiss(animated: true, completion: nil)
    }
    
    func joinGame () {
        let userID = Auth.auth().currentUser?.uid
        let gameKey = currentGame.gameID
        let refUser = Database.database().reference().child("users").child(userID!).child("joinedGames")
        refUser.updateChildValues([gameKey:"true"])
        let refGame = Database.database().reference().child("games").child(gameKey).child("joinedPlayers")
        refGame.updateChildValues([userID!:"true"])
        
    }
    
    func leaveGame () {
        let userID = Auth.auth().currentUser?.uid
        let gameKey = currentGame.gameID
        let refUser = Database.database().reference().child("users").child(userID!).child("joinedGames")
        refUser.child(gameKey).removeValue()
        let refGame = Database.database().reference().child("games").child(gameKey).child("joinedPlayers")
        refGame.child(userID!).removeValue()
    }
    
    func cancelGame () {
        let userID = Auth.auth().currentUser?.uid
        let gameKey = currentGame.gameID
        let refGame = Database.database().reference().child("games").child(gameKey)
        refGame.removeValue()
        let refUserHosted = Database.database().reference().child("users").child(userID!).child("hostedGames")
        refUserHosted.child(gameKey).removeValue()
        
        for id in currentGame.joinedPlayersArray {
            let ref = Database.database().reference().child("users").child(id).child("joinedGames")
            ref.child(gameKey).removeValue()
            }
        }
        
        

//    let refUserJoined = Database.database().reference().child("users").child(userID!).child("joinedGames").child(gameKey)
//        refUserJoined.removeValue()

    }







//let userID = Auth.auth().currentUser?.uid
//let ref = Database.database().reference().child("users").child(userID!).child("joinedGames")
//
//ref.observeSingleEvent(of: .value) {(snapshot) in
//    let value = snapshot.value as? [String:String] ?? [:]
//    let gamesArrayID = Array(value.keys)
//    for id in gamesArrayID {
//        let ref = Database.database().reference().child("games").child(id)
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//            let game = Game(snapshot: snapshot)
//            self.gamesArrayDetails.append(game)
//            self.tableView.reloadData()
//        }
//    }
//}

