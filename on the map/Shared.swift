//
//  Shared.swift
//  on the map
//
//  Created by Jing Jia on 11/2/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import Foundation
import UIKit

class Shared: NSObject {
    
    
    class func showError(vc: UIViewController,errorString : String){
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            vc.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    class func showLocationVC(vc: UIViewController){
        let locationController = vc.storyboard!.instantiateViewControllerWithIdentifier("locationViewController") as! LocationViewController
        locationController.origin = vc
        vc.presentViewController(locationController, animated: true, completion: nil)
    }
    
    //set up preview location vc and pass data
    class func showPreviewLocationVC(origin: UIViewController, vc: UIViewController, data: [String:AnyObject]){
        let previewLocationController = vc.storyboard!.instantiateViewControllerWithIdentifier("previewLocationViewController") as! PreviewLocationViewController
        previewLocationController.latitude = data["latitude"] as! Double
        previewLocationController.longitude = data["longitude"] as! Double
        previewLocationController.mapString = data["mapString"] as! String
        vc.dismissViewControllerAnimated(false, completion: nil)
        origin.presentViewController(previewLocationController, animated: true, completion: nil)
    }
}
