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
    
    func configureCell(with game: Game, indexPath: IndexPath ) {
        self.titleLabel.text = game.title
        self.locationLabel.text = "Location: \(game.address)"
        //            cell.locationLabel.font = cell.locationLabel.font.italic
        self.timeLabel.text = game.date
        self.costLabel.text = game.cost
        
        self.skillLabel.text = "\(game.skillLevel)"
        let numberofPlayersString = String(game.spotsRemaining)
        
        self.spotsLabel.text = "\(numberofPlayersString) Spot(s)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        let gameDate = dateFormatter.date(from: game.date)
        if let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) {
            let month = gregorianCalendar.component(.month, from: gameDate!)
            let monthName = DateFormatter().monthSymbols[month - 1]
            self.monthLabel.text = String(monthName)
            let day = gregorianCalendar.component(.day, from: gameDate!)
            self.timeLabel.text = String (day)
            let hour = gregorianCalendar.component(.hour, from: gameDate!)
            let minute = gregorianCalendar.component(.minute, from: gameDate!)
            let dateAsString = String ("\(hour):\(minute)")
            let dateFormatterNew = DateFormatter()
            dateFormatterNew.dateFormat = "HH:mm"
            let date = dateFormatterNew.date(from: dateAsString)
            dateFormatterNew.dateFormat = "h:mm a"
            let Date12 = dateFormatterNew.string(from: date!)
            self.hourLabel.text = Date12
        }
        
        self.backgroundColor = UIColor.clear
        self.backgroundView = UIView()
        self.selectedBackgroundView = UIView()
        
        if(indexPath.row % 4 == 0) {
            self.roundedView.backgroundColor = UIColor.flatWhiteDark
        }
        else if(indexPath.row % 4 == 1) {
            self.roundedView.backgroundColor = UIColor.flatYellow
            self.costLabel.textColor = UIColor.flatNavyBlueDark
            self.skillLabel.textColor = UIColor.flatNavyBlueDark
            self.spotsLabel.textColor = UIColor.flatNavyBlueDark
        }
        else if(indexPath.row % 4 == 2) {
            self.roundedView.backgroundColor = UIColor.flatPowderBlue
        }
        else {
            self.roundedView.backgroundColor = UIColor.flatWhite
            self.timeLabel.textColor = UIColor.flatYellow
            self.costLabel.textColor = UIColor.flatNavyBlueDark
            self.skillLabel.textColor = UIColor.flatNavyBlueDark
            self.spotsLabel.textColor = UIColor.flatNavyBlueDark
            
        }
    }

}
