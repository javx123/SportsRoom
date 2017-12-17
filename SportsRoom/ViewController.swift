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
//    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showProfile))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createGame))
        
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        observeFireBase()
    }
    
    
    //Mark: - SearchBar Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    

    //Mark: - FireBase Methods
    
    func observeFireBase() {
        let childRef = Database.database().reference(withPath: "users/Jason")
        childRef.observe(DataEventType.value) { (snapshot) in
            let value = snapshot.value
            print("\(value)")
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

