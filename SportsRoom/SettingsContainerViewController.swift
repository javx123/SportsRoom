//
//  SettingsContainerViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-31.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class SettingsContainerViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var settingsTableView: UIView!
    
    var userSettingsVC: UserSettingsTableViewController?
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate = self
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UserSettingsTableViewController {
            userSettingsVC = vc
            vc.currentUser = currentUser
        }
    }

}
