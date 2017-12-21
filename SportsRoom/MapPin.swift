//
//  MapPin.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-21.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import MapKit

class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    
    init(latitude: Double, longitude: Double, title: String) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
    }
}


