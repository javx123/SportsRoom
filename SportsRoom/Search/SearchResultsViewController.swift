//
//  SearchResultsViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.


import UIKit
import MapKit
import FirebaseDatabase
import Firebase
import MBProgressHUD

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference(withPath: "games/")
    var currentUser: User?
    var searchedSport: String!
    var searchRadius: Int?
    var searchLocation: CLLocation?
    var pulledGames: [Game]?
    var locationManager: LocationManager
    var searchResults: [Game] = [] { didSet{ self.tableView.reloadData() } }
    var loadingNotification: MBProgressHUD?
    
    required init?(coder aDecoder: NSCoder) {
        self.locationManager = LocationManager(manager: CLLocationManager())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        let settingsImage = UIImage(named: "settingswhite-1")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        let settingsButton = UIButton(frame: iconSize)
        settingsButton.setBackgroundImage(settingsImage, for: .normal)
        let settingsBarButton = UIBarButtonItem(customView: settingsButton)
        settingsButton.contentMode = UIViewContentMode.scaleAspectFit
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = settingsBarButton
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        let inset = UIEdgeInsetsMake(10, 0, 0, 0);
        self.tableView.contentInset = inset
        
        if searchLocation == nil { callLocationManager() }
        pullMatchingGames()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Sorry! There are no results for that search"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Please try another sport"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    @objc func showSettings () {
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    
    func pullMatchingGames() {
        pullFireBaseData { (matchingGames) in
            print(matchingGames)
            DispatchQueue.main.async {
                self.pulledGames = matchingGames
                self.filterResults()
                self.ref.removeAllObservers()
            }
        }
    }
    
    func callLocationManager () {
        locationManager.getCurrentLocation { [weak self] (location: CLLocation) in
            guard let  `self` = self else { return }
            DispatchQueue.main.async {
                self.searchLocation = location
                self.filterResults()
            }
        }
    }
    
//    Mark: - Datasource methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else{fatalError("The dequeued cell is not an instance of SearchTableViewCell.")}
        let entry: Game? = searchResults[indexPath.row]
        cell.selectionStyle = .none
        if let entry = entry {
            cell.configureCell(with: entry, indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func pullFireBaseData(completion: @escaping ( _ games : [Game]) -> Void) {
        ref.queryOrdered(byChild: "sport").queryEqual(toValue: searchedSport.lowercased()).observe(.value) { (snapshot) in
//            quick fix for strange bug where sometimes the data pulled down is duplicated
            self.pulledGames?.removeAll()
            self.searchResults.removeAll()
            
            print(snapshot.value!)
            let pulledGames = snapshot.value as? Dictionary <String, Any>
            guard let games = pulledGames else {
                MBProgressHUD.hide(for: self.view, animated: true)
                return }
            var matchingGames: [Game] = []
            for game in games {
                print(game.value)
                let gameValue = game.value as! Dictionary <String, Any>
                print(gameValue)
                print("\n\n\n\n\n\n")
                let game = Game(gameInfo: gameValue)
    
                print(game)
                matchingGames.append(game)
            }
            completion(matchingGames)
        }

        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "Searching"
        
    }
    
    func filterResults() {
//        Attempt quick fix to stop duplicates
        self.searchResults.removeAll()

        guard let pulledGames = pulledGames else {
            print("Pulled games doesn't exist")
            return }
        guard let searchLocation = searchLocation else {
            print("Search location doesn't exist")
            return }
        
            MBProgressHUD.hide(for: self.view, animated: true)
        
        for game in pulledGames {
            let gameCoordinates = CLLocation(latitude: game.latitude, longitude: game.longitude)
            let distance = searchLocation.distance(from: gameCoordinates)
            print(distance)

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
            let gameDate = dateFormatter.date(from: game.date)
            if Date() < gameDate! {
            if ( Int(distance) < searchRadius!){
                if !(currentUser!.joinedGameArray!.contains(game.gameID)) && !(currentUser!.hostedGameArray!.contains(game.gameID)) {
                    if (game.joinedPlayersArray!.count < game.numberOfPlayers) {
                        game.distance = Int(distance)
                        self.searchResults.append(game)
//                        sortGames()
                    }
                }
            }
        }
        }

        print("nothing test")
//        Can put sortGames() here, which would definetly make it more efficient then calling sortGames() many times, but in the current setup, although it's more inefficient, we ensure that the loading Icon only disappears after the sort is finished
        sortGames()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func sortGames (){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        
        switch self.currentUser?.settings!["filter"] as! String {
        case "date":
            self.searchResults.sort{ dateFormatter.date(from: $0.date)! < dateFormatter.date(from: $1.date)!}
        case "distance":
            print("implement later")
            self.searchResults.sort{ $0.distance! <  $1.distance! }
        default:
            print("no filter???")
        }

    }
    
    func updateUserInfo () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            self.currentUser = User(snapshot: snapshot)
//            self.sortGames()
            self.filterResults()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "search") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let game = searchResults[indexPath.row]
                let VC2 : DetailsViewController = segue.destination as! DetailsViewController
                VC2.btnText =  DetailsViewController.ButtonState.search
                VC2.currentGame = game
                VC2.longitude = game.longitude
                VC2.latitude = game.latitude
                VC2.address = game.address
            }
        }
        
        if segue.identifier == "showSettings" {
            let userSettingsVC = segue.destination as? SettingsContainerViewController
            userSettingsVC?.currentUser = currentUser
        }
    }
    
    @IBAction func unwindFromSettings (sender: UIStoryboardSegue) {
        if sender.source is SettingsContainerViewController {
            if let senderVC = sender.source as? SettingsContainerViewController {
                let userID = Auth.auth().currentUser!.uid
                let ref = Database.database().reference().child("users").child(userID)
                
                let userSearchRadius = senderVC.userSettingsVC?.searchRadius
                
                switch senderVC.userSettingsVC?.filterType {
                case .date?:
                    let defaultSettings: [String : Any] = ["radius": userSearchRadius ?? 0, "filter": "date"]
                    ref.updateChildValues(["settings" : defaultSettings])
                case .distance?:
                    let defaultSettings: [String : Any] = ["radius" : userSearchRadius ?? 0, "filter": "distance"]
                    ref.updateChildValues(["settings" : defaultSettings])
                case .none:
                    // Should never hit this case, if this happens then it means that there was an issue pulling data
                    print("Invalid filtertype")
                }
                
                
                searchRadius = senderVC.userSettingsVC?.searchRadius
                searchResults.removeAll()
                loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                if pulledGames == nil {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                updateUserInfo()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let loadingIcon = loadingNotification {
            MBProgressHUD.hide(for: loadingIcon, animated: true)
        }
    }
    
    deinit { print("This is deinitialized") }
    
}

extension UIFont {
    var bold: UIFont { return with(traits: .traitBold) }
    var italic: UIFont { return with(traits: .traitItalic) }
    var boldItalic: UIFont { return with(traits: [.traitBold, .traitItalic]) }
    
    func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else { return self }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
    
}

