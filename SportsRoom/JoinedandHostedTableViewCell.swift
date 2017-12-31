//
//  JoinedTableViewCell.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-26.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class JoinedandHostedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
