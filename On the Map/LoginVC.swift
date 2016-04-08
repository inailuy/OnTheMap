//
//  LoginVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(signupButton)
    }
    
    @IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("segueModal", sender: nil)
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}