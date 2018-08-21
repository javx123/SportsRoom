//
//  JoinedTableViewCell.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-26.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class JoinedandHostedTableViewCell: UITableViewCell {

    @IBOutlet weak var blueView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    // Mark: - Private keys for default sport types
    private enum SportKeys {
        static let basketBall = "basketball"
        static let baseBall = "baseball"
        static let hockey = "hocky"
        static let tennis = "tennis"
        static let squash = "squash"
        static let tableTennis = "table tennis"
        static let softBall = "softball"
        static let footBall = "football"
        static let soccer = "soccer"
        static let ultimate = "ultimate"
        static let rugby = "rugby"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(with game: Game) {
        self.titleLabel.text = game.title
        self.dateLabel.text = game.date
        self.costLabel.text = game.cost
        self.skillLabel.text = "Skill Level: \(game.skillLevel)"
        
        switch game.sport {
        case SportKeys.basketBall :
            self.sportImage.image = UIImage(named: "basketball-1")
        case SportKeys.baseBall:
            self.sportImage.image = UIImage(named: "baseball-1")
        case SportKeys.hockey:
            self.sportImage.image = UIImage(named: "hockey-1")
        case SportKeys.tennis:
            self.sportImage.image = UIImage(named: "tennis-1")
        case SportKeys.squash:
            self.sportImage.image = UIImage(named: "squash-1")
        case SportKeys.tableTennis:
            self.sportImage.image = UIImage(named: "tabletennis-1")
        case SportKeys.softBall:
            self.sportImage.image = UIImage(named: "softball-1")
        case SportKeys.footBall:
            self.sportImage.image = UIImage(named: "football2")
        case SportKeys.soccer:
            self.sportImage.image = UIImage(named: "soccer-1")
        case SportKeys.ultimate:
            self.sportImage.image = UIImage(named: "ultimate-1")
        case SportKeys.rugby:
            self.sportImage.image = UIImage(named: "rugby")
        default:
            self.sportImage.image = UIImage(named: "default1")
        }
        self.locationLabel.text = game.address
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}


