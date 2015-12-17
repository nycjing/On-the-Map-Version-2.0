//
//  LocationViewController.swift
//  on the map
//
//  Created by Jing Jia on 12/1/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationLabel: UITextField!
    
    var origin : UIViewController!
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: UIButton) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        CLGeocoder().geocodeAddressString(locationLabel.text!, completionHandler: { (placemarks, error)->Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error == nil {
        //        let place = placemarks![0] as! CLPlacemark
                let place = placemarks![0]
                let coordinate = place.location!.coordinate
                Shared.showPreviewLocationVC(self.origin,vc: self, data: ["latitude": coordinate.latitude, "longitude": coordinate.longitude, "mapString": "\(place.locality), \(place.administrativeArea)"])
            }else{
                Shared.showError(self, errorString: error!.localizedDescription)
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationLabel.delegate = self
    }
    
    // Getting rid of keyboard after hitting return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Getting rid of keyboard after touching outside inputs
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event!)
    }
}
