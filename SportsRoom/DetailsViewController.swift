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
import SDWebImage

class DetailsViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    var playersArray: [User] = []
    
    var playerName = String ()
    var playerAge = String ()
    var playerEmail = String ()
    var playerBio = String ()
    var playerPhoto = String ()
    var currentUser : User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonState(buttonState: btnText!)
        setLabels()
        getPlayerNames()
        collectionView.delegate = self
        collectionView.dataSource = self
        notesLabel.sizeToFit()
    }
    
    func setLabels(){
        gameTitleLabel.text = currentGame.title
        
        let capitalizedSportString = currentGame.sport.capitalized
        sportLabel.text = capitalizedSportString
//        sportLabel.text = currentGame.sport
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
//            gameActionBtn.backgroundColor = UIColor.red
        case .hosted:
            gameActionBtn.setTitle(ButtonState.hosted.rawValue, for: UIControlState.normal)
//            gameActionBtn.backgroundColor = UIColor.red
        case .search:
            gameActionBtn.setTitle(ButtonState.search.rawValue, for: UIControlState.normal)
//            gameActionBtn.backgroundColor = UIColor.green
        }
    }
    
    //    Mark: - DataSource Properties
    
    func getPlayerNames() {
        for id in currentGame.allPlayersArray {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                let user = User(snapshot: snapshot)
                self.playerNamesArray.append(user.name)
                self.playersArray.append(user)
                self.collectionView.reloadData()
            }
        }
    }
    
    // Mark: - Collection View Properties
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerNamesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath)
        if let cell = cell as? PlayersListCollectionViewCell {
            let name = playerNamesArray[indexPath.item]
            cell.playerLabel.text = name
            let currentUser = playersArray[indexPath.item]
            let photoString = currentUser.profileImageURLString
            if photoString == "" {
                cell.playerImage.image = UIImage(named:"defaultimage")
            } else {
                cell.playerImage.sd_setImage(with: URL(string: photoString))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = playersArray[indexPath.item]
        self.playerName = selectedUser.name
        self.playerAge = selectedUser.age
        self.playerEmail = selectedUser.email
        self.playerBio = selectedUser.bio
        self.playerPhoto = selectedUser.profileImageURLString
        currentUser = selectedUser
        self.performSegue(withIdentifier: "showProfile", sender: self)
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
        
        let MessagingTopic = "Message"
        Messaging.messaging().subscribe(toTopic: "/topics/\(gameKey)")
        Messaging.messaging().subscribe(toTopic: "/topics/\(gameKey)\(MessagingTopic)")
    }
    
    func leaveGame () {
        let userID = Auth.auth().currentUser?.uid
        let gameKey = currentGame.gameID
        let refUser = Database.database().reference().child("users").child(userID!).child("joinedGames")
        refUser.child(gameKey).removeValue()
        let refGame = Database.database().reference().child("games").child(gameKey).child("joinedPlayers")
        refGame.child(userID!).removeValue()
        
        let MessagingTopic = "Message"
        Messaging.messaging().unsubscribe(fromTopic: "/topics/\(gameKey)")
        Messaging.messaging().unsubscribe(fromTopic: "/topics/\(gameKey)\(MessagingTopic)")
        
        self.navigationController?.popViewController(animated: true)
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
        
        let MessagingTopic = "Message"
        Messaging.messaging().unsubscribe(fromTopic: "/to pics/\(gameKey)\(MessagingTopic)")
        
        self.navigationController?.popViewController(animated: true)
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
        if segue.identifier == "showProfile"{
            let locationVC = segue.destination as! ProfileViewController
            locationVC.currentUser = currentUser
//            locationVC.name = playerName
//            locationVC.age = playerAge
//            locationVC.email = playerEmail
//            locationVC.about = playerBio
//            locationVC.profilePhotoString = playerPhoto
        }
    }
}








