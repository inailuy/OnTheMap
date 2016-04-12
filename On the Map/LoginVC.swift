//
//  LoginVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: BaseVC , UITextFieldDelegate, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        
    }
    
    @IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        //let login = LoginModel(username: emailTextField.text!, password: passwordTextField.text!)
        let login = LoginModel(email: "inailuy@me.com", password: "Ynn75112")
        NetworkArchitecture.sharedInstance .creatingSession(login, loginVC: self)
        
        startAnimatingIndicator()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                NetworkArchitecture.sharedInstance.fbAcessToken = result.token
                NetworkArchitecture.sharedInstance .creatingSession(nil, loginVC: self)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
            let login = LoginModel(email: emailTextField.text!, password: passwordTextField.text!)
            NetworkArchitecture.sharedInstance .creatingSession(login, loginVC: self)
            startAnimatingIndicator()
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    internal func dismissView() {
        performSegueWithIdentifier("segueModal", sender: nil)
    }
}