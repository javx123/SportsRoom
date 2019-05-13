//
//  PlayersListCollectionViewCell.swift
//  SportsRoom
//
//  Created by Daniel Grosman on 2017-12-29.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class PlayersListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerImage.layer.borderWidth = 1
        playerImage.layer.masksToBounds = false
        playerImage.layer.borderColor = UIColor.clear.cgColor
        playerImage.layer.cornerRadius = playerImage.frame.height/2
        playerImage.clipsToBounds = true
    }
    
}
