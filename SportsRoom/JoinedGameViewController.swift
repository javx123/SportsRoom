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
//        addGameButton.setTitle("+", for: .normal)
        self.tableView.separatorStyle = .none
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
    
    
    @IBAction func addGame(_ sender: Any) {
        performSegue(withIdentifier: "createGame", sender: self)
    }
    
    //    Mark: - DataSource Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return gamesArrayDetails.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinCell", for: indexPath)
        if let cell = cell as? JoinedandHostedTableViewCell {
            let currentGame = gamesArrayDetails[indexPath.row]
            cell.titleLabel.text = currentGame.title
            cell.dateLabel.text = currentGame.date
            cell.costLabel.text = currentGame.cost
            cell.skillLabel.text = "Skill Level: \(currentGame.skillLevel)"
            
            switch currentGame.sport {
            case "basketball":
                cell.sportImage.image = UIImage(named: "basketball")
            case "baseball":
                cell.sportImage.image = UIImage(named: "baseball")
            case "badminton":
                cell.sportImage.image = UIImage(named: "badminton")
            case "hockey":
                cell.sportImage.image = UIImage(named: "hockey")
            case "tennis":
                cell.sportImage.image = UIImage(named: "tennis")
            case "squash":
                cell.sportImage.image = UIImage(named: "squash")
            case "table tennis":
                cell.sportImage.image = UIImage(named: "tabletennis")
            case "softball":
                cell.sportImage.image = UIImage(named: "softball")
            case "football":
                cell.sportImage.image = UIImage(named: "football")
            case "soccer":
                cell.sportImage.image = UIImage(named: "soccer")
            case "ball hockey":
                cell.sportImage.image = UIImage(named: "hockey")
            default:
                cell.sportImage.image = UIImage(named: "defaultsport")
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
        return IndicatorInfo(title: "Joined Games")
    }
    
}
