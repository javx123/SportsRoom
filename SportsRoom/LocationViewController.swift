//
//  LocationViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UINavigationBarDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar: UINavigationBar = UINavigationBar()
        self.view.addSubview(navBar)
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self
            , action: #selector(backTapped))
        let leftNavItem = UINavigationItem()
        leftNavItem.leftBarButtonItem = backButton

        navBar.setItems([leftNavItem], animated: false)
        
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}
