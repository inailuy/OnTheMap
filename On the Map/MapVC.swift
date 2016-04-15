//
//  MapVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
import MapKit

class MapVC: BaseVC, MKMapViewDelegate {
    @IBOutlet weak var mapview: MKMapView!
    var mapAnnotations : NSMutableArray!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
   //MARK: Button Actions
    @IBAction func postButtonPressed(sender: AnyObject) {
        NetworkArchitecture.sharedInstance.getStudentLocation()
        performSegueWithIdentifier("seguePosting", sender: nil)
    }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        performLogout()
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
       fetchData()
    }
    //MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation){
            return nil;
        }
        let annotationId = "annotationId"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
        annotationView.image = UIImage(named: "mapPin")
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let annotation = view.annotation as! LocationAnnotation
        let url = NSURL(string: annotation.mediaURL)
        if url != nil {
            UIApplication.sharedApplication().openURL(url!)
        } else {
            handleErrors("Link is not a proper URL")
        }
    }
    
    func addAnnotationsToMap() {
        mapAnnotations = NSMutableArray()
        mapview.removeAnnotations(mapview.annotations)
        for studentLocation in NetworkArchitecture.sharedInstance.studentLocationArray {
            let coordination = CLLocationCoordinate2DMake(Double(studentLocation.latitude), Double(studentLocation.longitude))
            let title = studentLocation.fullName()
            let annotation = LocationAnnotation(title: title, coordinate: coordination, info: studentLocation.mediaURL,
                                                mediaURL: studentLocation.mediaURL, subtitle: studentLocation.mediaURL)
            mapAnnotations.addObject(annotation)
        }
        mapview.addAnnotations(mapAnnotations as NSArray as! [LocationAnnotation])
    }
    //MARK: Misc
    func fetchData() {
        mapview.alpha = 0.4
        startAnimatingIndicator()
        NetworkArchitecture.sharedInstance.getStudentLocations({ (errorString: String?) in
            dispatch_async(dispatch_get_main_queue(), {
                self.mapview.alpha = 1.0
                self.stopAnimatingIndicator()
                if errorString == nil {
                    self.addAnnotationsToMap()
                } else {
                    self.handleErrors(errorString!)
                }
            })
        })
    }
}