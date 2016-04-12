//
//  BaseVC.swift
//  On the Map
//
//  Created by inailuy on 4/8/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRectMake(view.frame.size.width/2 - 25, view.frame.size.height/2 - 25, 50, 50);
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopAnimatingIndicator()
        super.viewWillDisappear(animated)
    }
    
    func startAnimatingIndicator(){
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopAnimatingIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    internal func handleErrors(errorMessage: String) {
        stopAnimatingIndicator()
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func performLogout() {
        if NetworkArchitecture.sharedInstance.fbAcessToken != nil {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            NetworkArchitecture.sharedInstance.fbAcessToken = nil
        } else {
            NetworkArchitecture.sharedInstance.deletingSession()   
        }
    }
}