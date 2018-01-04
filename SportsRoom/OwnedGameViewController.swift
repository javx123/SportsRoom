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
        self.tableView.separatorStyle = .none
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
                VC2.longitude = game.longitude
                VC2.latitude = game.latitude
                VC2.address = game.address
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
    
    @IBAction func addGame(_ sender: Any) {
        performSegue(withIdentifier: "createGameFromHosted", sender: self)
    }
    
    //    Mark: - DataSource Properties
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return gamesArrayDetails.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath)
        if let cell = cell as? JoinedandHostedTableViewCell {
            let currentGame = gamesArrayDetails[indexPath.row]
            cell.titleLabel.text = currentGame.title
            cell.dateLabel.text = currentGame.date
            cell.costLabel.text = currentGame.cost
            cell.skillLabel.text = "Skill Level: \(currentGame.skillLevel)"
            
            switch currentGame.sport {
            case "basketball":
                cell.sportImage.image = UIImage(named: "basketball-1")
            case "baseball":
                cell.sportImage.image = UIImage(named: "baseball-1")
            case "hockey":
                cell.sportImage.image = UIImage(named: "hockey-1")
            case "tennis":
                cell.sportImage.image = UIImage(named: "tennis-1")
            case "squash":
                cell.sportImage.image = UIImage(named: "squash-1")
            case "table tennis":
                cell.sportImage.image = UIImage(named: "tabletennis-1")
            case "softball":
                cell.sportImage.image = UIImage(named: "softball-1")
            case "football":
                cell.sportImage.image = UIImage(named: "football2")
            case "soccer":
                cell.sportImage.image = UIImage(named: "soccer-1")
            case "ultimate":
                cell.sportImage.image = UIImage(named: "ultimate-1")
            case "rugby":
                cell.sportImage.image = UIImage(named: "rugby")
            default:
                cell.sportImage.image = UIImage(named: "default1")
            }
            cell.locationLabel.text = currentGame.address
            cell.chatButton.tag = indexPath.row
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
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
