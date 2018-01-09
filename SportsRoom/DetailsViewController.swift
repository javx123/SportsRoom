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
import MBProgressHUD

class DetailsViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var skillView: UIView!
    @IBOutlet weak var infoView: UIView!
    
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
    
    var latitude: Double?
    var longitude: Double?
    var address: String?
    
    var selectedPin : MKPlacemark?
//    var loadingNotification: MBProgressHUD?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameDetails()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        mapView.delegate = self
        mapView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupGameDetails() {
        switch btnText! {
        case .joined:
            updateGame()
        case .hosted:
            updateGame()
        case .search:
            setupView()
        }
    }
    
    func setupView() {
        
        getPlayerNames()
        setLabels()
        setButtonState(buttonState: btnText!)
        notesLabel.sizeToFit()
        
        costView.layer.cornerRadius = costView.frame.size.height/2
        costView.layer.borderColor = UIColor.white.cgColor
        costView.layer.borderWidth = 1
        skillView.layer.cornerRadius = skillView.frame.size.height/2
        skillView.layer.borderColor = UIColor.flatNavyBlueDark.cgColor
        skillView.layer.borderWidth = 1
        infoView.layer.cornerRadius = infoView.frame.size.height/2
        infoView.layer.borderColor = UIColor.flatYellow.cgColor
        infoView.layer.borderWidth = 1
        
        let currentLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        selectedPin = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude!, longitude!), addressDictionary: nil)
        updateMapView(currentLocation)
        dropPinZoomIn(placemark: selectedPin!)
        
//        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func updateGame() {
        let currentGameID = currentGame.gameID
        
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading Details"
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let ref = Database.database().reference().child("games").child(currentGameID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            self.currentGame = Game(snapshot: snapshot)
            self.setupView()
        }
    }
    
    func updateMapView(_ location: CLLocation) {
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func dropPinZoomIn(placemark:MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.red
        return pinView
    }
    
    func setLabels(){
        switch currentGame.sport {
        case "basketball":
            sportImageView.image = UIImage(named: "basketball")
//            backgroundImageView.image = UIImage(named: "basketball-1")
        case "baseball":
            sportImageView.image = UIImage(named: "baseball")
//            backgroundImageView.image = UIImage(named: "baseball-1")
        case "hockey":
            sportImageView.image = UIImage(named: "hockey")
//            backgroundImageView.image = UIImage(named: "hockey-1")
        case "tennis":
            sportImageView.image = UIImage(named: "tennis")
//            backgroundImageView.image = UIImage(named: "tennis-1")
        case "squash":
            sportImageView.image = UIImage(named: "squash")
//            backgroundImageView.image = UIImage(named: "squash-1")
        case "table tennis":
            sportImageView.image = UIImage(named: "tabletennis")
//            backgroundImageView.image = UIImage(named: "tabletennis-1")
        case "softball":
            sportImageView.image = UIImage(named: "softball")
//            backgroundImageView.image = UIImage(named: "softball-1")
        case "football":
            sportImageView.image = UIImage(named: "football")
//            backgroundImageView.image = UIImage(named: "football2")
        case "soccer":
            sportImageView.image = UIImage(named: "soccer")
//            backgroundImageView.image = UIImage(named: "soccer-1")
        case "ultimate":
            sportImageView.image = UIImage(named: "ultimate")
//            backgroundImageView.image = UIImage(named: "ultimate-1")
        case "rugby":
            sportImageView.image = UIImage(named: "football")
//            backgroundImageView.image = UIImage(named: "rugby")
        default:
            sportImageView.image = UIImage(named: "defaultsport")
//            backgroundImageView.image = UIImage(named: "default1")
        }
        gameTitleLabel.text = currentGame.title
        dateLabel.text = currentGame.date
        locationLabel.text = currentGame.address
        skillLabel.text = "Skill: \(currentGame.skillLevel)"
        costLabel.text = currentGame.cost
        notesLabel.text = currentGame.notes
        let playersString = String(currentGame.spotsRemaining)
        playersLabel.text = "\(playersString) Spot(s)"
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
//        MBProgressHUD.hide(for: self.view, animated: true)
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
        
        let spotsKey  = "spotsRemaining"
        let SpotsRemaining = currentGame.spotsRemaining
        let newSpotsRemaining = SpotsRemaining - 1
        let refSpots = Database.database().reference().child("games").child(gameKey)
        refSpots.updateChildValues([spotsKey:newSpotsRemaining])
        
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
        
        let spotsKey  = "spotsRemaining"
        let SpotsRemaining = currentGame.spotsRemaining
        let newSpotsRemaining = SpotsRemaining + 1
        let refSpots = Database.database().reference().child("games").child(gameKey)
        refSpots.updateChildValues([spotsKey:newSpotsRemaining])
        
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








