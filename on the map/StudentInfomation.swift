//
//  StudentInfomation.swift
//  on the map
//
//  Created by Jing Jia on 12/1/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    
    static var students = [StudentInformation]()
    
    var firstName : String = ""
    var lastName : String = ""
    var mediaURL: String = ""
    var lat: CLLocationDegrees = 0.0
    var lng: CLLocationDegrees = 0.0
    
    init(data: [String:AnyObject]){
        self.firstName = data["firstName"] as! String
        self.lastName = data["lastName"] as! String
        self.mediaURL = data["mediaURL"] as! String
        self.lat = CLLocationDegrees(data["latitude"] as! Double)
        self.lng = CLLocationDegrees(data["longitude"] as! Double)
    }
    
    //Self-explanatory ... get data about user
    func getName() -> String{
        return "\(self.firstName) \(self.lastName)"
    }
    
    func getURL() -> String{
        return self.mediaURL
    }
    
    func getLat() -> CLLocationDegrees{
        return self.lat
    }
    func getLng() -> CLLocationDegrees{
        return self.lng
    }
    func getCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
    
}
