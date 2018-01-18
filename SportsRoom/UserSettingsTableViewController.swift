//
//  UserSettingsTableViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-31.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import ChameleonFramework

class UserSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchRadiusSlider: UISlider!
    @IBOutlet weak var searchRadiusLabel: UILabel!
    @IBOutlet weak var dateFilterCell: UITableViewCell!
    @IBOutlet weak var distanceFilterCell: UITableViewCell!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var currentUser: User?
    var filterType: Filter?
    var searchRadius: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRadiusSlider()
        setupFilters()
        tableView.allowsSelection = false
    }

    // MARK: - tableViewDataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    //MARK: - Settings
    
    func setupRadiusSlider () {
        searchRadiusSlider.value = (currentUser?.settings!["radius"] as! Float) / 1000
        searchRadius = Int(searchRadiusSlider.value) * 1000
        searchRadiusLabel.text = "\(Int(searchRadiusSlider.value)) Km"
    }
    
    func setupFilters () {
        if (currentUser?.settings!["filter"] as? String) == "date" {
            filterType = Filter.date
            dateFilterSelected(self)
        }
        else if (currentUser?.settings!["filter"] as? String) == "distance" {
            filterType = Filter.distance
            distanceFilterSelected(self)
        }
    }

    @IBAction func dateFilterSelected(_ sender: Any) {
        print("Date filter tapped")
        filterType = Filter.date

        dateFilterCell.backgroundColor = UIColor.flatYellow
        dateLabel.textColor = UIColor.flatNavyBlueDark
        
        distanceFilterCell.backgroundColor = UIColor.flatNavyBlueDark
        distanceLabel.textColor = UIColor.flatYellow
    }
    
    @IBAction func distanceFilterSelected(_ sender: Any) {
        print("Distance filter tapped")
        filterType = Filter.distance
        distanceFilterCell.backgroundColor = UIColor.flatYellow
        distanceLabel.textColor = UIColor.flatNavyBlueDark
        
        dateFilterCell.backgroundColor = UIColor.flatNavyBlueDark
        dateLabel.textColor = UIColor.flatYellow
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
