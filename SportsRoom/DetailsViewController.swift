//
//  DetailsViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import CoreLocation
import MapKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    
    enum ButtonState: String {
        case joined = "Leave Game"
        case hosted = "Cancel Game"
        case search = "Join Game"
    }
    
    @IBOutlet weak var gameActionBtn: UIButton!
    
    var btnText : ButtonState?
    var currentGame: Game!
    var playerNamesArray = [String] ()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonState(buttonState: btnText!)
        setLabels()
        getPlayerNames()
    }
    
    func setLabels(){
        gameTitleLabel.text = currentGame.title
        sportLabel.text = currentGame.sport
        dateLabel.text = currentGame.date
        locationLabel.text = currentGame.address
        skillLabel.text = currentGame.skillLevel
        costLabel.text = currentGame.cost
        notesLabel.text = currentGame.notes
        locationLabel.isUserInteractionEnabled = true
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
    
    func getPlayerNames() {
            for id in currentGame.allPlayersArray {
                let ref = Database.database().reference().child("users").child(id)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    let user = User(snapshot: snapshot)
                    self.playerNamesArray.append(user.name)
                    self.tableView.reloadData()
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        let name = playerNamesArray[indexPath.row]
        cell.textLabel?.text = name
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
        
        Messaging.messaging().subscribe(toTopic: "/topics/\(gameKey)")
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
        
        for id in currentGame.joinedPlayersArray! {
            let ref = Database.database().reference().child("users").child(id).child("joinedGames")
            ref.child(gameKey).removeValue()
        }
    }
    
    @IBAction func showLocation(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showLocation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocation"{
            let locationVC = segue.destination as! LocationViewController
            locationVC.address = currentGame.address
            locationVC.latitude = currentGame.latitude
            locationVC.longitude = currentGame.longitude
        }
    }
}








