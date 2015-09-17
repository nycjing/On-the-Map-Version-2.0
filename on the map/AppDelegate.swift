//
//  AppDelegate.swift
//  on the map
//
//  Created by Jing Jia on 9/1/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

        /* Constants for Udacity*/
        let udacity_apiKey = "365362206864879"
        let baseURLString = "http://www.udacity.com/api/session"
        let baseURLSecureString = "https://www.udacity.com/api/session"
        
        /* Need these for login */
        var requestToken: String? = nil
        var sessionID: String? = nil
        var userID: Int? = nil
        
        var config = Config()
        
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            
            /* If necessary, update the configuration */
            config.updateIfDaysSinceUpdateExceeds(7)
            
            return true
        }
    }
    
    // MARK: - Helper
    
    extension AppDelegate {
        
        /* Helper function: Given a dictionary of parameters, convert to a string for a url */
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
            
            return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
        }
        
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }



