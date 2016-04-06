//
//  MapVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapVC: UIViewController {
    @IBOutlet weak var mapview: MKMapView!
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("seguePosting", sender: nil)
    }

    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}