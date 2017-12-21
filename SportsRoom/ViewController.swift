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
import XLPagerTabStrip
import MapKit


class ViewController: ButtonBarPagerTabStripViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    let searchBar: UISearchBar = UISearchBar()
    var pulledData: Dictionary<String,Any> = [:]
    var currentUser: User?
    
    
    var createButton = UIBarButtonItem()
    var profileButton = UIBarButtonItem()
    
    @IBOutlet weak var addGameButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(createGame))
        profileButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showProfile))
        
        self.navigationItem.leftBarButtonItem = profileButton
        self.navigationItem.rightBarButtonItem = createButton
        
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        observeFireBase()
        createCurrentUser()
        configureView()
        enableLocationServices()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "searchGame", sender: self)
        searchBar.text = ""
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
        performSegue(withIdentifier: "showProfile", sender: self)
    }
    
    @objc func createGame () {
        performSegue(withIdentifier: "createGame", sender: self)
    }
    
    deinit {
        //remove removeobservers
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "joinedGame")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hostedGame")
        return [child_1, child_2]
    }
    
    func configureView() {
        let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = purpleInspireColor
        }
    }
    
    func enableLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case CLAuthorizationStatus.notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func createCurrentUser () {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            self.currentUser = User(snapshot: snapshot)
        }
    }

    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchGame" {
            let navController = segue.destination as! UINavigationController
            let searchController = navController.topViewController as! SearchResultsViewController
            
            searchController.searchedSport = searchBar.text
            searchController.currentUser = currentUser
            
//            searchBar.setShowsCancelButton(false, animated: true)
//            searchBar.endEditing(true)
//            self.navigationItem.setLeftBarButton(profileButton, animated: true)
//            self.navigationItem.setRightBarButton(createButton, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        self.navigationItem.setLeftBarButton(profileButton, animated: true)
        self.navigationItem.setRightBarButton(createButton, animated: true)
    }
    
    
}

