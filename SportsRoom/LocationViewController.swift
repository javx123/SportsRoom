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

class LocationViewController: UIViewController, UINavigationBarDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    var latitude: Double?
    var longitude: Double?
    var address: String?

    var selectedPin : MKPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        selectedPin = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude!, longitude!), addressDictionary: nil)
        updateMapView(currentLocation)
        dropPinZoomIn(placemark: selectedPin!)
        
        mapView.delegate = self
    }

    func updateMapView(_ location: CLLocation) {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

func dropPinZoomIn(placemark:MKPlacemark) {

    selectedPin = placemark

    mapView.removeAnnotations(mapView.annotations)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = placemark.coordinate
    annotation.title = address
    mapView.addAnnotation(annotation)
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegionMake(placemark.coordinate, span)
    mapView.setRegion(region, animated: true)
}

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.red
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 47, height: 47)
        let point = CGPoint(x: 0, y: 0)
        let button = UIButton(frame: CGRect(origin: point, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car700"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }

    @objc func getDirections(){
        if let selectPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectPin)
            mapItem.name = address
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }

}

