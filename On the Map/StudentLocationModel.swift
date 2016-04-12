//
//  StudentLocationModel.swift
//  On the Map
//
//  Created by inailuy on 4/10/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocationModel {
    var objectId : String
    var uniqueKey: String
    var firstName : String
    var lastName : String
    var mapString : String
    var mediaURL : String
    var latitude : Float
    var longitude : Float
    
    func objectToString() -> String {
       return "{\"uniqueKey\": "+uniqueKey+", \"firstName\": "+firstName+", \"lastName\": "+lastName+",\"mapString\": "+mapString+", \"mediaURL\": "+mediaURL+",\"latitude\": "+String(latitude)+", \"longitude\": "+String(longitude)+"}"
    }
}
