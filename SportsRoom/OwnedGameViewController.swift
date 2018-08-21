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

class OwnedGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        //        getHostedGames()
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        let inset = UIEdgeInsetsMake(3, 0, 0, 0);
        self.tableView.contentInset = inset
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Welcome to SportsRoom"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You currently have no hosted games.\r\nTap the '+' button below to add your own game"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
//    func updateGames () {
//        let userID = Auth.auth().currentUser?.uid
//        let ref = Database.database().reference().child("users").child(userID!).child("hostedGames")
//        ref.observe(.value) { (snapshot) in
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
//    }
    
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
    
    //    Mark: - DataSource Properties
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return gamesArrayDetails.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath)
        if let cell = cell as? JoinedandHostedTableViewCell {
            let currentGame = gamesArrayDetails[indexPath.row]
            cell.configCell(with: currentGame, indexPath: indexPath)
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
