//
//  InfoPostingVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InfoPostingVC: BaseVC, UITextViewDelegate {
    
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    var placeholderText: String!
    var placemark: CLPlacemark!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        let text = textView.text
        if text == "Enter Your Location Here" || text == "Enter a Link to Share Here" {
            placeholderText = text
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderText
        }
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        startAnimatingIndicator()
        if sender.titleLabel?.text == "Find on the Map" {
            loadGeocodeAddressString()
        } else {
            if urlTextView.text != "Enter a Link to Share Here" {
                let uniqueKey = NetworkArchitecture.sharedInstance.userModel.uniqueKey
                let firstName = NetworkArchitecture.sharedInstance.userModel.firstName
                let lastName = NetworkArchitecture.sharedInstance.userModel.lastName
                let mapString = self.locationTextView.text
                let mediaURL = self.urlTextView.text
                let coord = self.placemark.location!.coordinate
                var objectId = ""
                if (NetworkArchitecture.sharedInstance.currentStudentLocation != nil){
                    objectId = NetworkArchitecture.sharedInstance.currentStudentLocation.objectId
                }
                
                let studentLocation = StudentLocationModel(objectId: objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: Float((coord.latitude)), longitude: Float((coord.longitude)))
                
                NetworkArchitecture.sharedInstance.postStudentLocation(studentLocation, completion: { (didFinished: Bool) in
                    if didFinished == true {
                        self.dismissViewControllerAnimated(true, completion: {})
                    }
                })
            } else {
                handleErrors("Enter Valid URL")
            }
        }
    }
    
    func loadGeocodeAddressString() {
        let geocoder = CLGeocoder()
        let location = self.locationTextView.text
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            self.stopAnimatingIndicator()
            if (error != nil) {
                self.handleErrors(error!.localizedDescription)
                return
            }
            self.placemark = placemarks![0] as CLPlacemark
            self.switchUI(self.placemark)
        })
    }
    @IBAction func tapGestureRecognized(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func switchUI(placemark: CLPlacemark) {
        // animating map to the correct location
        let coor = placemark.location?.coordinate
        let region = MKCoordinateRegion(center: coor!, span: MKCoordinateSpanMake(0.02, 0.02))
        let adjustedRegion = self.mapView.regionThatFits(region)
        self.mapView.setRegion(adjustedRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coor!
        self.mapView.addAnnotation(annotation)
        
        studyLabel.hidden = true
        locationTextView.hidden = true
        urlTextView.hidden = false
        
        topView.backgroundColor = view.backgroundColor
        
        bottomView.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        submitButton.setTitle("Submit", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        mapView.hidden = false
    }
}