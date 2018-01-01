//
//  JoinedTableViewCell.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-26.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class JoinedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
