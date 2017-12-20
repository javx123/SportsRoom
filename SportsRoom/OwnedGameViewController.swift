//
//  OwnedGameViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class OwnedGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    var gamesArrayID = [String]()
    var gamesArrayDetails = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getHostedGameForUser()
        getHostedGames()
    }
    
//    func getHostedGameForUser() {
//        let currentUser = Auth.auth().currentUser?.uid
//        let g = Database.database().reference().child("games")
//        g.queryOrdered(byChild:"hostID").queryEqual(toValue: currentUser).observe(.value)
//                    { (snapshot) in
//                        self.gamesArray.append(snapshot.value!)
//                        print(snapshot)
//            }
//    }
    
    func getHostedGames () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!).child("hostedGames")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? [String:String]
            self.gamesArrayID = Array(value!.keys)
        }
        for games in gamesArrayID {
            let ref = Database.database().reference().child("games").child(games)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                
            }

        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "hosted") {
            let VC2 : DetailsViewController = segue.destination as! DetailsViewController
            VC2.btnText =  DetailsViewController.ButtonState.hosted
        }
    }
    
    //    Mark: - DataSource Properties
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return gamesArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath)
        let currentGame = gamesArray[indexPath.row]
//        cell.textLabel?.text =
//        cell.detailTextLabel?.text 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Hosted Games")
    }
    
}
