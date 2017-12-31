//
//  UserSettingsTableViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-31.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class UserSettingsTableViewController: UITableViewController {
    
    var currentUser: User?
    
    @IBOutlet weak var searchRadiusSlider: UISlider!
    @IBOutlet weak var searchRadiusLabel: UILabel!
    
    @IBOutlet weak var dateFilterCell: UITableViewCell!
    @IBOutlet weak var distanceFilterCell: UITableViewCell!
    
    var filterType: Filter?
    var searchRadius: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        searchRadiusSlider.value = (currentUser?.settings!["radius"] as! Float) / 1000
//        searchRadius = Int(searchRadiusSlider.value) * 1000
//        searchRadiusLabel.text = "\(Int(searchRadiusSlider.value)) Km"
//
//
//        if (currentUser?.settings!["filter"] as? String) == "date" {
//            filterType = Filter.date
////            dateFilterCell == selected someway
//        }
//        else if (currentUser?.settings!["filter"] as? String) == "distance" {
//            filterType = Filter.distance
////            distanceFilterCell == selected someway
//        }
        

        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            print("There is no section 3  yet!!")
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .black
        }
    }

    @IBAction func dateFilterSelected(_ sender: UITapGestureRecognizer) {
        print("Date filter tapped")
        filterType = Filter.date
        dateFilterCell.backgroundColor = UIColor(red: 251, green: 199, blue: 0, alpha: 1)
        distanceFilterCell.backgroundColor = UIColor(red: 34, green: 46, blue: 64, alpha: 1)
    }
    
    @IBAction func distanceFilterSelected(_ sender: UITapGestureRecognizer) {
        print("Distance filter tapped")
        filterType = Filter.distance
        distanceFilterCell.backgroundColor = UIColor(red: 251, green: 199, blue: 0, alpha: 1)
        dateFilterCell.backgroundColor = UIColor(red: 34, green: 46, blue: 64, alpha: 1)
    }
    
    @IBAction func searchRadiusChanged(_ sender: UISlider) {
        let searchDistance = sender.value * 1000
        searchRadius = Int(searchDistance)
        searchRadiusLabel.text = "\(Int(searchRadiusSlider.value)) Km"
    }
    
    

}

enum Filter {
    case date
    case distance
}
