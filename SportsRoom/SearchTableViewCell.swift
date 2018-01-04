//
//  SearchTableViewCell.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-19.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.layer.cornerRadius = 7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
