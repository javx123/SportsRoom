//
//  SearchResultsViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentUser: User?
    var searchedSport: String!
    var currentLocation: CLLocation?
    var pulledGames: [Game]?
    var searchResults: [Game] = []
    {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var locationManager: LocationManager
    let ref = Database.database().reference(withPath: "games/")
    
    
    required init?(coder aDecoder: NSCoder) {
        self.locationManager = LocationManager(manager: CLLocationManager())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callLocationManager()
        pullMatchingGames()
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
                self.currentLocation = location
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
        
        if let entry = entry {
            cell.titleLabel.text = entry.title
            cell.sportLabel.text = entry.sport
            cell.locationLabel.text = entry.address
            cell.timeLabel.text = entry.date
            return cell
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func pullFireBaseData(completion: @escaping ( _ games : [Game]) -> Void) {
        
        ref.queryOrdered(byChild: "sport").queryEqual(toValue: searchedSport.lowercased()).observe(.value) { (snapshot) in
            print(snapshot.value!)
            let pulledGames = snapshot.value as? Dictionary <String, Any>
            guard let games = pulledGames else { return }
            var matchingGames: [Game] = []
            for game in games {
                print(game.value)
                let gameValue = game.value as! Dictionary <String, Any>
                print(gameValue)
                print("\n\n\n\n\n\n")
                
                let game = Game(address: gameValue["address"] as! String, latitude: gameValue["latitude"] as! Double, longitude: gameValue["longitude"] as! Double, cost: gameValue["cost"] as! String, date: gameValue["date"] as! String, hostID: gameValue["hostID"] as! String, notes: gameValue["notes"] as! String, numberOfPlayers: gameValue["numberOfPlayers"] as! Int, skillLevel: gameValue["skillLevel"] as! String, sport: gameValue["sport"] as! String, title: gameValue["title"] as! String, gameID: gameValue["gameID"] as! String)
                
                print(game)
                matchingGames.append(game)
            }
            completion(matchingGames)
        }
        
    }
    
    func filterResults() {
        guard let `pulledGames` = pulledGames else { return }
        guard let `currentLocation` = currentLocation else { return }
        
        for game in pulledGames {
            let gameCoordinates = CLLocation(latitude: game.latitude, longitude: game.longitude)
            let distance = currentLocation.distance(from: gameCoordinates)
            print(distance)
            if ( Int(distance) < 30000 ){
                if !(currentUser!.joinedGameArray!.contains(game.gameID)) && !(currentUser!.hostedGameArray!.contains(game.gameID)) {
                    self.searchResults.append(game)
                    print(self.searchResults, "\n\n\n\n\n")
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "search") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let game = searchResults[indexPath.row]
                let VC2 : DetailsViewController = segue.destination as! DetailsViewController
                VC2.btnText =  DetailsViewController.ButtonState.search
                VC2.currentGame = game
            }
        }
    }
    
}
