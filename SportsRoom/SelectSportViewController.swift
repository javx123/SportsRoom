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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
   @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    @IBAction func sportButtonTapped(_ sender: UIButton) {
        sportSelectionLabel.text = sender.title(for: .normal)
    }
    
    @IBAction func enterPressed(_ sender: Any) {
        sportSelectionLabel.text = otherSportTextField.text
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        otherSportTextField.resignFirstResponder()
    }
    
}
