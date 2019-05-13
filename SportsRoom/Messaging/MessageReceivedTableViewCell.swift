//
//  MessageReceivedTableViewCell.swift
//  SportsRoom
//
//  Created by Larry Luk on 2018-01-04.
//  Copyright © 2018 Javier Xing. All rights reserved.
//

import UIKit

class MessageReceivedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var senderLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackground.layer.cornerRadius = 10
        // Initialization code
    }

}
