//
//  StaticFunctions.swift
//  SportsRoom
//
//  Created by Larry Luk on 2017-12-21.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import Foundation
import UIKit

class StaticFunctions {
    
    static func displayAlert (title: String, message: String, uiviewcontroller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        uiviewcontroller.present(alertController, animated: true, completion: nil)
    }
    
}
