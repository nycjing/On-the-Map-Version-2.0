//
//  ViewController.swift
//  Udacity_login
//
//  Created by Jing Jia on 9/19/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//
import UIKit


class ViewController: UIViewController {
    

    @IBOutlet weak var showWindow: UITextView!
        
    @IBAction func touchRefreshButton(sender: AnyObject) {
        //getPostJson()
        getJson()
        
       // getPostJson()
    }
    
    @IBAction func touchLeaveButton(sender: AnyObject) {
        deletePostJson()
    }
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getPostJson() {
        
        
       let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"nycjing@gmail.com\", \"password\": \"Spring2014\"}}".dataUsingEncoding(NSUTF8StringEncoding)
      // self.showWindow.text = String(stringInterpolationSegment: request)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println("Could not complete the request \(error)")
            } else{
                
               var parsingError: NSError? = nil
                //self.showWindow.text = String(stringInterpolationSegment: data)
                
               let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */

               let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)  as! NSDictionary

                //println("done")
              NSLog("Login SUCCESS")
               println(String(stringInterpolationSegment: parsedResult))
                
                if let session = parsedResult["session"] as? NSDictionary {
                    
                    let expiration = session["expiration"] as? String
                    let session_ID = session["id"] as? String
                    println(session_ID)
                    
               //     println(parsedResult)
               //     self.showWindow.text = String(stringInterpolationSegment: session_ID)
                    self.appDelegate.sessionID = session_ID
                   
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
          //              self.debugTextLabel.text = "Login Failed (Session ID)."
                        
                         println("Could not find session_id in \(parsedResult)")
                    }

               }

                         }

        }

        task.resume()

        
    }
    
    
    func deletePostJson(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println("Could not complete the request \(error)")
            }else{
            var parsingError: NSError? = nil
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)  as! NSDictionary
            println(String(stringInterpolationSegment: parsedResult))
        }
        }
        task.resume()
    }
    
    func getJson(){
        
        
      //  let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/u31119234")!)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "GET"
        let kAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        let kRestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        request.addValue(kAppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(kRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil { // Handle error...
            println("Could not complete the request \(error)")
        }else{
            var parsingError: NSError? = nil
           // let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)  as! NSDictionary
            println(String(stringInterpolationSegment: parsedResult))

        }
    }
    task.resume()}
   }