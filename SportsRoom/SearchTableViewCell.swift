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
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var spotsLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.layer.cornerRadius = 5
        let path = UIBezierPath(roundedRect:blurView.bounds,
                                byRoundingCorners:[.bottomLeft, .topLeft],
                                cornerRadii: CGSize(width: 4, height:  4))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        blurView.layer.mask = maskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
