//
//  FriendProfileViewController.swift
//  SportsRoom
//
//  Created by Daniel Grosman on 2017-12-25.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import SDWebImage

class FriendProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var name = String()
    var age = String()
    var email = String()
    var about = String()
    var profilePhotoString: String?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    var profileImage = UIImage ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        ageLabel.text = age
        emailLabel.text = email
        aboutLabel.text = about
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForImage()
    }
    
    func checkForImage () {
        if profilePhotoString == "" {
            imageView.image = UIImage(named:"defaultimage")
        } else {
            self.imageView.sd_setImage(with: URL(string: profilePhotoString!))
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
