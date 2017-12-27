//
//  TestDropDownViewController.swift
//  SportsRoom
//
//  Created by Daniel Grosman on 2017-12-27.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import DropDown

class TestDropDownViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dropLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.anchorView = stackView
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        textField.isHidden = true
        textField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dropDown.selectionAction = { (index: Int, item: String) in
            if item == "Truck" {
            self.textField.isHidden = false
            } else {
            self.dropLabel.text = item
    }
    }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dropLabel.text = self.textField.text
        return true
    }

    @IBAction func buttonPressed(_ sender: Any) {
        dropDown.show()
    }
    
    

    }
    
    


