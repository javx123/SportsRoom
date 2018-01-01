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
//    var delegate: gamesOwnerVC?
    

    var gamesArrayDetails: [Game] = []
    {
        didSet{
            if let tableView = self.tableView {
                tableView.reloadData()
            }
        }
    }


    var buttonTag = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        getHostedGames()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        delegate?.reassignData()
//        getHostedGames()
//        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        gamesArrayDetails = [Game]()
    }
    
    func getHostedGames () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!).child("hostedGames")
        
//        ref.observeSingleEvent(of: .value) {(snapshot) in
//            let value = snapshot.value as? [String:String] ?? [:]
//            let gamesArrayID = Array(value.keys)
//            for id in gamesArrayID {
//                let ref = Database.database().reference().child("games").child(id)
//                ref.observeSingleEvent(of: .value) { (snapshot) in
//                    let game = Game(snapshot: snapshot)
//                    self.gamesArrayDetails.append(game)
//                    self.tableView.reloadData()
//                }
//            }
//        }
        ref.observe(.value) { (snapshot) in
            let value = snapshot.value as? [String:String] ?? [:]
            let gamesArrayID = Array(value.keys)
            for id in gamesArrayID {
                let ref = Database.database().reference().child("games").child(id)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    let game = Game(snapshot: snapshot)
                    self.gamesArrayDetails.append(game)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "hosted") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let game = gamesArrayDetails[indexPath.row]
                let VC2 : DetailsViewController = segue.destination as! DetailsViewController
                VC2.btnText =  DetailsViewController.ButtonState.hosted
                VC2.currentGame = game
            }
        } else if (segue.identifier == "toChat") {
            if let sender = sender as? UIButton {
                let game = gamesArrayDetails[sender.tag]
                let nav = segue.destination as! UINavigationController
                let chatVC = nav.topViewController as! ChatViewController
                chatVC.currentGame = game
            }
        }
    }
    
    
    //    Mark: - DataSource Properties
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return gamesArrayDetails.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath)
        if let cell = cell as? OwnedGameTableViewCell {
            let currentGame = gamesArrayDetails[indexPath.row]
            cell.titleLabel.text = currentGame.title
            cell.sportLabel.text = currentGame.sport
            cell.chatButton.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Hosted Games")
    }
    
}
