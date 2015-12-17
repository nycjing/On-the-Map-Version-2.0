//
//  ParseConstant.swift
//  on the map
//
//  Created by Jing Jia on 12/14/15.
//  Copyright © 2015 Jing Jia. All rights reserved.
//

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ParseAppId : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Parameters
        static let Limit : Int = 100
        static let Order = "-updatedAt"
        
        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Parse
        static let Parse = "https://api.parse.com/1/classes/StudentLocation"
        
        // MARK: Udacity
        static let GetUserData = "https://www.udacity.com/api/users/{id}"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let Limit = "limit"
        static let Order = "order"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: StudentInformation
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
        
    }
    
    
}