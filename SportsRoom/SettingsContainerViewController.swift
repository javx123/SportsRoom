//
//  SettingsContainerViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-31.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class SettingsContainerViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var settingsTableView: UIView!
    
    var userSettingsVC: UserSettingsTableViewController?
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UserSettingsTableViewController {
            userSettingsVC = vc
            vc.currentUser = currentUser
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
