//
//  LoginViewController.swift
//  on the map
//
//  Created by Jing Jia on 9/1/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController , UITextFieldDelegate {
    
   
    @IBOutlet weak var headerTextLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    @IBOutlet weak var loginButton: LoginButton!

    @IBOutlet weak var debugTextLabel: UILabel!
    
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var backgroundGradient: CAGradientLayer? = nil
    var tapRecognizer: UITapGestureRecognizer? = nil

    /* Based on student comments, this was added to help with smaller resolution devices */
   // var keyboardAdjusted = false
   // var lastKeyboardOffset : CGFloat = 0.0
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self

        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - Keyboard Fixes
    
   func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @IBAction func moveKeyboard(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    //Alert
    
    func dismissAlert(alert: UIAlertAction!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func openAlertView(errorMessage: String){
        let alrtController : UIAlertController = UIAlertController (title: "Error Message: ", message: errorMessage, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction (title: "Cancel", style: .Cancel, handler: dismissAlert)
        alrtController.addAction(cancelAction)
        self.presentViewController(alrtController, animated: true, completion: nil)
    }
    @IBAction func signUp(sender: UIButton) {
        UdaClient.showSignUp()
    }
    
    @IBAction func sendButton(sender: UIButton) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        UdaClient.login(usernameTextField.text!,password: passwordTextField.text!){ (success, jsonData) in
            if(success){
                self.finishLogin(jsonData)

            }else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errorText = jsonData["error"] as! String
                Shared.showError(self, errorString: errorText)
            }
        }
    }
    
    func finishLogin(data : [String:AnyObject?]){
        dispatch_async(dispatch_get_main_queue(), {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let account = data["account"] as! [String:AnyObject]
            let accountKey = account["key"] as! String
            appDelegate.accountKey = accountKey
            UdaClient.getPublicData(accountKey, completionHandler: {(success,data) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if(success){
                    let user = data["user"] as! [String:AnyObject]
                    appDelegate.firstName = user["first_name"] as! String
                    appDelegate.lastName = user["last_name"] as! String
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else{
                    Shared.showError(self, errorString: data["ErrorString"] as! String)
                }
            })
        })
    }
    
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.debugTextLabel.text = errorString
            }
        })
    }
    
    func configureUI() {
        /* Configure background gradient */
        view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        /* Configure header text label */
        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        headerTextLabel.textColor = UIColor.whiteColor()
        
        /* Configure debug text label */
        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        debugTextLabel.textColor = UIColor.whiteColor()
        
        // Configure login button
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        loginButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
        loginButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        loginButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
}


