//
//  LoginVC.swift
//  On the Map
//
//  Created by inailuy on 4/5/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Indenting Textfields
        indentTextField(emailTextField)
        indentTextField(passwordTextField)
        
    }
    //MARK: Button/Gesture Actions
    @IBAction func loginButtonPressed(sender: UIButton) {
        let login = LoginModel(email: emailTextField.text!, password: passwordTextField.text!)
        NetworkArchitecture.sharedInstance .creatingSession(login, loginVC: self)
        
        startAnimatingIndicator()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil){
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            if result.grantedPermissions.contains("email") {
                NetworkArchitecture.sharedInstance.fbAcessToken = result.token
                NetworkArchitecture.sharedInstance.creatingSession(nil, loginVC: self)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //FBSDK Required Method
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
            NetworkArchitecture.sharedInstance.creatingSession(login, loginVC: self)
            startAnimatingIndicator()
        }
        return true
    }
    
    @IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    //MARK: Misc
    internal func dismissView() {
        performSegueWithIdentifier("segueModal", sender: nil)
    }
    
    func indentTextField(textField:  UITextField) {
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:15, height:15))
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.leftView = spacerView
    }
}