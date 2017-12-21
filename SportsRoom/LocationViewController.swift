//
//  LocationViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, UINavigationBarDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var currentLocationPin : MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        
    }
    
    func setupMapView() {
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        camera.altitude = 1000
        mapView.camera = camera
        
        let currentLocationAnnotation = MapPin(latitude: latitude!, longitude: longitude!, title: address!)
        mapView.addAnnotation(currentLocationAnnotation)
    }
    
}







