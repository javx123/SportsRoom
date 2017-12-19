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
    var currentLocation:CLLocationCoordinate2D?
    
    @IBOutlet weak var addGameButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(createGame))
        let profileButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showProfile))
        
        self.navigationItem.leftBarButtonItem = profileButton
        self.navigationItem.rightBarButtonItem = createButton
        
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        observeFireBase()
        configureView()
        //        enableLocationServices()
        //        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
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
//        self.navigationItem.setLeftBarButton(profileButton, animated: true)
//        self.navigationItem.setRightBarButton(createButton, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let ref = Database.database().reference(withPath: "Games/")
        ref.queryOrdered(byChild: "type").queryEqual(toValue: "soccor").observe(.childAdded) { (snapshot) in
            self.pulledData = snapshot.value as! Dictionary
            print(self.pulledData)
        }
        locationManager.requestLocation()
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
    
    @objc func createGame () {
//        let controller = HostGameViewController()
//        self.present(controller, animated: true, completion: nil)
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
    //
    //    func disableLocationFeatures(){
    //        locationManager.stopUpdatingLocation()
    //
    //    }
    //    func enableLocationFeatures(){
    //        locationManager.startUpdatingLocation()
    //    }
    //
    //    //Mark: CLLocationManagerDelegate
    //
    //    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //        switch status {
    //        case CLAuthorizationStatus.authorizedWhenInUse:
    //            enableLocationFeatures()
    //        case CLAuthorizationStatus.restricted:
    //            disableLocationFeatures()
    //        case CLAuthorizationStatus.denied:
    //            disableLocationFeatures()
    //        case CLAuthorizationStatus.authorizedAlways:
    //            break
    //        case CLAuthorizationStatus.notDetermined:
    //            break
    //        }
    //    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got location updates")
        var localValue: CLLocationCoordinate2D = manager.location!.coordinate
        //        print("Found location: (\(localValue.latitude), \(localValue.longitude))")
        currentLocation = localValue
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location \(error.localizedDescription)")
    }
    
}

