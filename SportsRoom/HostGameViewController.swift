//
//  HostGameViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class HostGameViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gameTitleTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var skillLevelControl: UISegmentedControl!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var numberOfPlayersSlider: UISlider!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func sliderChanged(_ sender: Any) {
        (sender as AnyObject).setValue(Float(lroundf(numberOfPlayersSlider.value)), animated: true)
        let sliderValue: Float = numberOfPlayersSlider.value
        let sliderNSNumber = sliderValue as NSNumber
        var playerString:String = sliderNSNumber.stringValue
        numberOfPlayersLabel.text = playerString
    }
}
