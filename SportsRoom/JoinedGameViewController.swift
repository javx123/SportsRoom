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

class JoinedGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {
    
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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
//        addGameButton.setTitle("+", for: .normal)
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
        let str = "You currently have no Joined Games.\r\nTap the search icon in the top right corner to search for an open game"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "joined") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let game = gamesArrayDetails[indexPath.row]
                let VC2 : DetailsViewController = segue.destination as! DetailsViewController
                VC2.btnText =  DetailsViewController.ButtonState.joined
                VC2.currentGame = game
                VC2.longitude = game.longitude
                VC2.latitude = game.latitude
                VC2.address = game.address
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
        return IndicatorInfo(title: "Joined Games")
    }
    
}
