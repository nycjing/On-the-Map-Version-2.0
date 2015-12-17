//
//  ParseClient.swift
//  on the map
//
//  Created by Jing Jia on 12/1/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    let baseURL : String
    
    var appID : String
    var apiKey : String
    var session: NSURLSession
    
    override init() {
        self.appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        self.apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        self.baseURL = "https://api.parse.com/1/classes/StudentLocation"
        self.session = NSURLSession.sharedSession()
 
        super.init()
    }
    
    
    func storeData(data:[[String:AnyObject]]){
        StudentInformation.students = []
        for student in data{
            StudentInformation.students.append(StudentInformation(data: student))
        }
    }
    
    // Retrieve student data
    func getStudents(completionHandler: (success: Bool ,data: [String:AnyObject]) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let params = ["limit": 100, "order": "-updatedAt",]
        let urlString = baseURL + escapedParameters(params)
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue("\(self.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(self.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                completionHandler(success: false, data: ["error": "\(error!.localizedDescription)"])
                return
            }else{
                let parsedData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! [String:AnyObject]
                completionHandler(success: true, data: parsedData )
            }
            
        }
        task.resume()
    }
    //POST request
    func postStudent(studentInfo : StudentInformation, mapString: String, completionHandler:(success:Bool, data1:[String:AnyObject]) ->Void){
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
          request.HTTPMethod = "POST"

        request.addValue("\(self.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(self.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let uniqueKey = appDelegate.accountKey
        
        let jsonBody : [String:AnyObject] = [
            JSONResponseKeys.UniqueKey: uniqueKey,
            JSONResponseKeys.FirstName: studentInfo.firstName,
            JSONResponseKeys.LastName: studentInfo.lastName,
            JSONResponseKeys.MapString: mapString,
            JSONResponseKeys.MediaURL: studentInfo.mediaURL,
            JSONResponseKeys.Latitude: studentInfo.lat,
            JSONResponseKeys.Longitude: studentInfo.lng
        ]
        
   //     let urlString = Methods.Parse
     //   let url = NSURL(string: urlString)!
       // let request = NSMutableURLRequest(URL: url)
      //  request.HTTPMethod = "POST"
        request.addValue(Constants.ParseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandler(success: false, data1: ["error": "Network connection error."])
   
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(success: false, data1: ["error": "Your request returned an invalid response! Status code: \(response.statusCode)!"])
                } else if let response = response {
                    completionHandler(success: false, data1: ["error": "Your request returned an invalid response! Response: \(response)!"])
                } else {
                    completionHandler(success: false, data1: ["error": "Your request returned an invalid response!"])
                }
                return
            }
            
            guard let data = data else {
                completionHandler(success: false, data1: ["error": "No data was returned by the request!"])
                return
            }
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: { (result, error) -> Void in
                if error != nil {
                    completionHandler(success: false, data1: ["error": "Data parse failed."])
                } else {
                    guard let _ = result["objectId"] else {
                        completionHandler(success: false, data1: ["error": "Data doesn't contain an objectId"])
                        return
                    }
    
                    completionHandler(success: true, data1: result as! [String : AnyObject])
                }
            })
            
        }
        
        /* 7. Start the request */
        task.resume()
        
    }
    

        
   //     request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(studentInfo.firstName)\", \"lastName\": \"\(studentInfo.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(studentInfo.getURL())\",\"latitude\": \(studentInfo.lat), \"longitude\": \(studentInfo.lng)}".dataUsingEncoding(NSUTF8StringEncoding)
    //    let session = NSURLSession.sharedSession()
    //    let task = session.dataTaskWithRequest(request) { data, response, error in
      //      if error != nil {
        //        completionHandler(success: false, data: ["ErrorString":error!.localizedDescription])
        //    }
        //    else{
            //    var error:NSError? = nil
    //            let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! [String:AnyObject]
   //             print(jsonData)
    //            completionHandler(success: true, data : jsonData)
                

    //        }
    //    }
    //    task.resume()
//    }
    
    /*
    
    */
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
   
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
}