//
//  JoinedGameViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

//protocol gamesOwnerVC {
//    func reassignData()
//}

class JoinedGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider  {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        delegate?.reassignData()
//        getJoinedGames()
//        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        gamesArrayDetails = [Game]()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "joined") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let game = gamesArrayDetails[indexPath.row]
                let VC2 : DetailsViewController = segue.destination as! DetailsViewController
                VC2.btnText =  DetailsViewController.ButtonState.joined
                VC2.currentGame = game
            }
        } else if (segue.identifier == "toChat2") {
                if let sender = sender as? UIButton {
                    let game = gamesArrayDetails[sender.tag]
                    let nav = segue.destination as! UINavigationController
                    let chatVC = nav.topViewController as! ChatViewController
                    chatVC.currentGame = game
                }
            }
        }
    
    
    
    //    Mark: - DataSource Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return gamesArrayDetails.count
    }
    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "joinCell", for: indexPath)
//        let game = gamesArrayDetails[indexPath.row]
//        cell.textLabel?.text = game.title
//        cell.detailTextLabel?.text = game.sport
//        return cell
//    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinCell", for: indexPath)
        if let cell = cell as? JoinedTableViewCell {
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
        return IndicatorInfo(title: "Joined Games")
    }
    
}
