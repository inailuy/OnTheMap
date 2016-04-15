//
//  BaseVC.swift
//  On the Map
//
//  Created by inailuy on 4/8/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
class BaseVC: UIViewController, UIAlertViewDelegate {
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRectMake(view.frame.size.width/2 - 25, view.frame.size.height/2 - 25, 50, 50);
        view.addSubview(activityIndicator)
    }
    //MARK: Spinner Animation
    func startAnimatingIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
    }
    
    func stopAnimatingIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    //MARK: Misc
    internal func handleErrors(errorMessage: String) {
        stopAnimatingIndicator()
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func performLogout() {
            NetworkArchitecture.sharedInstance.deletingSession({ (didFinished: Bool, errorString: String?) in
                dispatch_async(dispatch_get_main_queue(), {
                    if errorString != nil {
                        self.handleErrors(errorString!)
                    } else {
                        self.dismissViewControllerAnimated(true, completion: {})
                    }
                })
            })
    }
}