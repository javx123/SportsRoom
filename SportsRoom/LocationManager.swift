//
//  LocationManager.swift
//  GoogleToolboxForMac
//
//  Created by Javier Xing on 2017-12-19.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    init(manager: CLLocationManager) {
        self.locationManager = manager
        super.init()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var currentLocationCompletion: ((CLLocation) -> ())?
    
    @available(iOS 9.0, *)
    func getCurrentLocation(completion: @escaping (CLLocation) -> () ) {
        currentLocationCompletion = completion
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager?.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationCompletion!(locations.first!)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
}
