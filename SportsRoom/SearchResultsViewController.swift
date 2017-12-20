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
    
    var searchedSport: String!
    var currentLocation: CLLocation?
    var pulledData: Dictionary<String,Any> = [:]
    
    var searchResults: [Dictionary<String, Any>]?
    var searchResultsArray: [Dictionary <String,Any>] = []
    {
        didSet{
            self.tableView.reloadData()
        }
    }
    var locationManager = LocationManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let locationManager = LocationManager()
//        locationManager.locationManager.delegate = self
        
        locationManager.getCurrentLocation { [weak self](location: CLLocation) in
            
//            guard let welf = self else {return}
            
            self?.pullFireBaseData { (gameCoordinates, searchedGame) in
                            let distance = location.distance(from: gameCoordinates)
                            print(distance)
                            //            print(searchedGame)
                            if ( Int(distance) < 30000 ){
                                self?.searchResultsArray.append(searchedGame)
                                print(self?.searchResultsArray, "\n\n\n\n\n")
                            }
                
                        }
        }

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "search") {
            let VC2 : DetailsViewController = segue.destination as! DetailsViewController
            VC2.btnText =  DetailsViewController.ButtonState.search
        }
    }
    
    
//    Mark: - Datasource methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResults?.count ?? 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
    
    func pullFireBaseData(completion: @escaping (_ coordinate: CLLocation, _ gameDetails : Dictionary<String, Any>) -> Void) {
        let ref = Database.database().reference(withPath: "games/")

        ref.queryOrdered(byChild: "sport").queryEqual(toValue: searchedSport.lowercased()).observe(.childAdded) { (snapshot) in
            self.pulledData = snapshot.value as! Dictionary
            for entry in self.pulledData {
                let key = entry.0 as String
                if (key == "coordinates"){
                    let dicCoordinates = entry.1 as! Dictionary<String, Any>
                    let gameCoordinates = CLLocation(latitude: dicCoordinates["latitude"] as! CLLocationDegrees , longitude: dicCoordinates["longitude"] as! CLLocationDegrees)
                    print(gameCoordinates)
                    completion(gameCoordinates, self.pulledData)
//                    print(self.pulledData)
                }
//                print("test")
            }
            
//            print(self.pulledData)
            
        }
        
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
