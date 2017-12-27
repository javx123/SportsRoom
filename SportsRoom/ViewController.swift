//
//  ViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-13.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import XLPagerTabStrip
import MapKit


class ViewController: ButtonBarPagerTabStripViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    let dateFormatter = DateFormatter()
    let searchBar: UISearchBar = UISearchBar()
    var pulledData: Dictionary<String,Any> = [:]
    var currentUser: User?
    var customLocation: CLLocation?
    var customAddress: String?
    var searchRadius: Int?
    var joinedGames: [Game] = []
    var hostedGames: [Game] = []
    var joinedGamesVC: JoinedGameViewController?
    var ownedGamesVC: OwnedGameViewController?

    var createButton = UIBarButtonItem()
    var profileButton = UIBarButtonItem()
    
    @IBOutlet weak var addGameButton: UIBarButtonItem!
    @IBOutlet weak var locationControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(createGame))
        profileButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showProfile))
        
        self.navigationItem.leftBarButtonItem = profileButton
        self.navigationItem.rightBarButtonItem = createButton
        
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        observeFireBase()
        createCurrentUser()
        configureView()
        setupDateFormatter()
        enableLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if customAddress == nil || customLocation == nil {
            locationControl.selectedSegmentIndex = 0
        }
//        createCurrentUser()
    }
    
    
    //Mark: - SearchBar Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        self.navigationItem.setLeftBarButton(profileButton, animated: true)
        self.navigationItem.setRightBarButton(createButton, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "searchGame", sender: self)
        searchBar.text = ""
    }
    
    
    //Mark: - FireBase Methods
    
    func observeFireBase() {
        let childRef = Database.database().reference(withPath: "users/Jason")
        childRef.observe(DataEventType.value) { (snapshot) in
            let value = snapshot.value
            print("\(String(describing: value))")
        }
        childRef.removeAllObservers()
        
    }
    
    //Mark: - NavBar Button Methods
    @objc func showProfile() {
        performSegue(withIdentifier: "showProfile", sender: self)
    }
    
    @objc func createGame () {
        performSegue(withIdentifier: "createGame", sender: self)
    }
    
    deinit {
        //remove removeobservers
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "joinedGame") as? JoinedGameViewController
        joinedGamesVC = child_1
//        child_1?.gamesArrayDetails = joinedGames
        joinedGamesVC?.gamesArrayDetails = joinedGames
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hostedGame") as? OwnedGameViewController
        ownedGamesVC = child_2
//        child_2?.gamesArrayDetails = hostedGames
        ownedGamesVC?.gamesArrayDetails = hostedGames
        
        return [child_1!, child_2!]
    }
    
    func configureView() {
        let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = purpleInspireColor
        }
    }
    
    func enableLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case CLAuthorizationStatus.notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func createCurrentUser () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        ref.observe(.value) { (snapshot) in
             self.currentUser = User(snapshot: snapshot)
            self.getJoinedGames()
            self.getHostedGames()
//            self.deleteExpiredGames()
            
        }
    }
    
    func setupDateFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
    }
    
    func deleteExpiredGames() {
        let userID = Auth.auth().currentUser?.uid

        for game in joinedGames {
            let gameDate = dateFormatter.date(from: game.date)
            if gameDate! < Date() {
                let gameKey = game.gameID
                let refUser = Database.database().reference().child("users").child(userID!).child("joinedGames")
                refUser.child(gameKey).removeValue()
                let refGame = Database.database().reference().child("games").child(gameKey).child("joinedPlayers")
                refGame.child(userID!).removeValue()
            }
        }
        
        for game in hostedGames {
            let gameDate = dateFormatter.date(from: game.date)
            if gameDate! < Date() {
                let gameKey = game.gameID
                let refGame = Database.database().reference().child("games").child(gameKey)
                    refGame.removeValue()
                let refUserHosted = Database.database().reference().child("users").child(userID!).child("hostedGames")
                    refUserHosted.child(gameKey).removeValue()
                
                for id in game.joinedPlayersArray! {
                    let ref = Database.database().reference().child("users").child(id).child("joinedGames")
                            ref.child(gameKey).removeValue()
                }
            }
        }
        
    }
    
//    func cancelGame () {
//        let userID = Auth.auth().currentUser?.uid
//        let gameKey = currentGame.gameID
//        let refGame = Database.database().reference().child("games").child(gameKey)
//        refGame.removeValue()
//        let refUserHosted = Database.database().reference().child("users").child(userID!).child("hostedGames")
//        refUserHosted.child(gameKey).removeValue()
//
//        for id in currentGame.joinedPlayersArray! {
//            let ref = Database.database().reference().child("users").child(id).child("joinedGames")
//            ref.child(gameKey).removeValue()
//        }
//    }
    
    
    
    func getJoinedGames () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!).child("joinedGames")
        
        ref.observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as? [String:String] ?? [:]
            let gamesArrayID = Array(value.keys)
            for id in gamesArrayID {
                let ref = Database.database().reference().child("games").child(id)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    let game = Game(snapshot: snapshot)
                    self.joinedGames.append(game)
                    self.joinedGamesVC?.gamesArrayDetails.append(game)
                    
                    let gameDate = self.dateFormatter.date(from: game.date)
                    if gameDate! < Date() {
                        let gameKey = game.gameID
                        let refUser = Database.database().reference().child("users").child(userID!).child("joinedGames")
                        refUser.child(gameKey).removeValue()
                        let refGame = Database.database().reference().child("games").child(gameKey).child("joinedPlayers")
                        refGame.child(userID!).removeValue()
                    }
//                    self.joinedGamesVC?.tableView.reloadData()
//                    else {
//                        self.joinedGames.append(game)
//                        self.joinedGamesVC?.gamesArrayDetails.append(game)
//                    }
                }
            }
        }
    }
    
    func getHostedGames () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!).child("hostedGames")
        
        ref.observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as? [String:String] ?? [:]
            let gamesArrayID = Array(value.keys)
            for id in gamesArrayID {
                let ref = Database.database().reference().child("games").child(id)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    let game = Game(snapshot: snapshot)
                    self.hostedGames.append(game)
                    self.ownedGamesVC?.gamesArrayDetails.append(game)
                    
                    let gameDate = self.dateFormatter.date(from: game.date)
                    if gameDate! < Date() {
                        let gameKey = game.gameID
                        let refGame = Database.database().reference().child("games").child(gameKey)
                        refGame.removeValue()
                        let refUserHosted = Database.database().reference().child("users").child(userID!).child("hostedGames")
                        refUserHosted.child(gameKey).removeValue()

                        for id in game.joinedPlayersArray! {
                            let ref = Database.database().reference().child("users").child(id).child("joinedGames")
                            ref.child(gameKey).removeValue()
                        }
                    }
//                    self.ownedGamesVC?.tableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func locationOptions(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customLocation = nil
            customAddress = nil
        case 1:
            performSegue(withIdentifier: "searchLocation", sender: self)
        default:
            print("No matching segment")
        }
    }
    
    @IBAction func unwindFromMap (sender: UIStoryboardSegue) {
        if sender.source is SetLocationViewController {
            if let senderVC = sender.source as? SetLocationViewController {
                customAddress = senderVC.addressString
                customLocation = CLLocation(latitude: senderVC.latitudeDouble, longitude: senderVC.longitudeDouble) 
            }
            if customAddress == "" || (customLocation?.coordinate.latitude == 0.0 && customLocation?.coordinate.longitude == 0.0) {
                locationControl.selectedSegmentIndex = 0
                customAddress = nil
                customLocation = nil
            }
        }
    }
    
    @IBAction func unwindFromSearch (sender: UIStoryboardSegue){
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchGame" {
            let navController = segue.destination as! UINavigationController
            let searchController = navController.topViewController as! SearchResultsViewController
            
            searchController.searchedSport = searchBar.text
            searchController.currentUser = currentUser
            searchController.searchLocation = customLocation
        }
        
        if segue.identifier == "searchLocation" {
            let navController = segue.destination as! UINavigationController
            let setLocationVC = navController.topViewController as! SetLocationViewController
            setLocationVC.gamePurpose = SetLocationViewController.Purpose.searchGame
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        self.navigationItem.setLeftBarButton(profileButton, animated: true)
        self.navigationItem.setRightBarButton(createButton, animated: true)
    }

}

