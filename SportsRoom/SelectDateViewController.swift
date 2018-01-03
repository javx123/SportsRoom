//
//  SelectDateViewController.swift
//  SportsRoom
//
//  Created by Daniel Grosman on 2017-12-28.
//  Copyright © 2017 Javier Xing. All rights reserved.
//
import Foundation
import UIKit

class SelectDateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateString = String ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged () {
        let dateFormatter = DateFormatter ()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateString = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
}
    
}
