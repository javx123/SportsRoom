//
//  ViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-13.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UISearchBarDelegate {
    let searchBar: UISearchBar = UISearchBar()
    let profileButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showProfile))
    let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createGame))
//    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = profileButton
        self.navigationItem.rightBarButtonItem = createButton
        
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        observeFireBase()
    }
    
    
    //Mark: - SearchBar Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        self.navigationItem.setLeftBarButton(profileButton, animated: true)
        self.navigationItem.setRightBarButton(createButton, animated: true)
    }
    

    //Mark: - FireBase Methods
    
    func observeFireBase() {
        let childRef = Database.database().reference(withPath: "users/Jason")
        childRef.observe(DataEventType.value) { (snapshot) in
            let value = snapshot.value
            print("\(String(describing: value))")
        }
        childRef.removeAllObservers()
        
    }
    
    //Mark: - NavBar Button Methods
    @objc func showProfile() {
        
    }
    
    @objc func createGame() {
        
    }
    
    deinit {
        //remove removeobservers
    }
    
    
}

