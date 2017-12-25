//
//  SelectSportViewController.swift
//  SportsRoom
//
//  Created by Daniel Grosman on 2017-12-23.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class SelectSportViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sportSelectionLabel: UILabel!
    @IBOutlet weak var otherSportTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherSportTextField.delegate = self
        sportSelectionLabel.isHidden = true
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        otherSportTextField.addTarget(self, action: #selector(textFieldReturned), for: UIControlEvents.editingDidEndOnExit)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sportButtonTapped(_ sender: UIButton) {
        sportSelectionLabel.text = sender.title(for: .normal)
        
    }
    
    @objc func textFieldReturned () {
        sportSelectionLabel.text = otherSportTextField.text
            otherSportTextField.resignFirstResponder()
        self.reloadInputViews()
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        otherSportTextField.resignFirstResponder()
    }
    
}
