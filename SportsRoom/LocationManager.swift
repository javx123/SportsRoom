//
//  LocationManager.swift
//  GoogleToolboxForMac
//
//  Created by Javier Xing on 2017-12-19.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    var currentLocation: CLLocation?
    let locationManager: CLLocationManager = CLLocationManager()
    
    
    var currentLocationCompletion: ((CLLocation) -> ())?
    
    @available(iOS 9.0, *)
    func getCurrentLocation(completion: @escaping (CLLocation) -> () ) {
        currentLocationCompletion = completion
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestLocation()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationCompletion!(locations.first!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    
}
