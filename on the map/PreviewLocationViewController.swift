//
//  PreviewLocationViewController.swift
//  on the map
//
//  Created by Jing Jia on 12/1/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import MapKit
import UIKit

class PreviewLocationViewController : UIViewController,MKMapViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var previewMap: MKMapView!
    @IBOutlet weak var urlField: UITextField!
    
    var latitude : Double!
    var longitude : Double!
    var mapString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previewMap.delegate = self
        self.urlField.delegate = self
    }
    
    @IBAction func dismiss(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func submitUrl(sender: UIButton) {
     let app = UIApplication.sharedApplication().delegate as! AppDelegate
    //    var app = UIApplication.sharedApplication().delegate
        let studentDict: [String : AnyObject] = ["latitude": self.latitude, "longitude": self.longitude, "firstName": app.firstName, "lastName": app.lastName, "mediaURL": urlField.text!]
        let studentInfo = StudentInformation(data: studentDict )
        ParseClient.sharedInstance().postStudent(studentInfo, mapString: self.mapString){(success,data) in
            if(success){
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else{
                Shared.showError(self,errorString: data["ErrorString"] as! String)
            }
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Setting up point
 
        let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 1))
        self.previewMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        //Adding attributes to the pin
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        annotation.title = "You are here: "
        self.previewMap.addAnnotation(annotation)
        
    }
    
    
    // Hide keyboard after touching elsewhere
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event!)
    }
    
    // Hide keyboard after return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}