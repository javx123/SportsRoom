//
//  UserSettingsViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-28.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {
    
    var currentUser: User?
    @IBOutlet weak var searchRadiusSlider: UISlider!
    @IBOutlet weak var searchRadiusLabel: UILabel!
    @IBOutlet weak var filterOptions: UISegmentedControl!
    var searchRadius: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchRadiusSlider.value = (currentUser?.settings!["radius"] as! Float) / 1000
        searchRadius = Int(searchRadiusSlider.value) * 1000
        searchRadiusLabel.text = "\(Int(searchRadiusSlider.value)) Km"
        
        if (currentUser?.settings!["filter"] as? String) == "date" {
            filterOptions.selectedSegmentIndex = 0
        }
        else if (currentUser?.settings!["filter"] as? String) == "distance" {
            filterOptions.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        let searchDistance = sender.value * 1000
        searchRadius = Int(searchDistance)
        searchRadiusLabel.text = "\(Int(searchRadiusSlider.value)) Km"
    }
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        
    }

}





