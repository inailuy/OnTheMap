//
//  LocationAnnotation.swift
//  On the Map
//
//  Created by inailuy on 4/11/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class LocationAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var mediaURL: String
    var subtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, mediaURL: String, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.mediaURL = mediaURL
        self.subtitle = subtitle
    }
}
