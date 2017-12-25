//
//  FriendProfileViewController.swift
//  SportsRoom
//
//  Created by Daniel Grosman on 2017-12-25.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController {
    
    var name = String()
    var age = String()
    var email = String()
    var about = String()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        ageLabel.text = age
        emailLabel.text = email
        aboutLabel.text = about
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
