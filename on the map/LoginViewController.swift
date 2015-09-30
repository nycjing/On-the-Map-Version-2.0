//
//  LoginViewController.swift
//  on the map
//
//  Created by Jing Jia on 9/1/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
   
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
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
   //     tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
        
        /* Configure the UI */
      //  self.configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
      //  self.addKeyboardDismissRecognizer()
        //self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
     //  self.removeKeyboardDismissRecognizer()
 //       self.unsubscribeToKeyboardNotifications()
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

    // MARK: - Login
    
   
     @IBAction func loginButtonTouch(sender: AnyObject) {
        
         debugTextLabel.text = nil
        if usernameTextField.text.isEmpty {
            debugTextLabel.text = "Username Empty."
            openAlertView("Username Empty.")
        } else if passwordTextField.text.isEmpty {
            debugTextLabel.text = "Password Empty."
            openAlertView("Password Empty.")
        } else {
            println("ID field \(usernameTextField.text)")
            println("password field \(passwordTextField.text)")
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       //   request.HTTPBody = "{\"udacity\": {\"username\": \(usernameTextField.text)\", \"password\": \(passwordTextField.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
            
           request.HTTPBody = "{\"udacity\": {\"username\": \"nycjing@gmail.com\", \"password\": \"Spring2014\"}}".dataUsingEncoding(NSUTF8StringEncoding)

            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
               self.debugTextLabel.text = "Could not complete the request"
               self.openAlertView("Could not complete the request")
            }else{
                
                var parsingError: NSError? = nil
                //self.showWindow.text = String(stringInterpolationSegment: data)
                
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)  as! NSDictionary
                
              if  parsedResult["error"] != nil {
                
                    self.debugTextLabel.text = parsedResult["error"] as? String
                
                    println("Error  \(self.usernameTextField.text) + \(self.debugTextLabel.text)")
                    self.openAlertView("UserID & Password not matching to the record")
                
                } else {
                
                //println("done")
                NSLog("Login SUCCESS")
                self.completeLogin()

                }
                }
            }
            task.resume()
        }
      }//

    
  /*  @IBAction func loginButtonTouch(sender: AnyObject) {
        UdaClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    // MARK: - LoginViewController
    */
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
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
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
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


