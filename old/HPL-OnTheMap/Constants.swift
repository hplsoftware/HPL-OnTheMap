//
//  Constants.swift
//  HPL-OnTheMap
//
//  Created by Rob Sutherland on 2017-04-15.
//  Copyright © 2017 HPL Software. All rights reserved.
//

import UIKit

// MARK: - Constants

struct Constants {
    
    struct UdacityAPI {
        static let ApiPath = "/api"
        static let BaseURL = "https://www.udacity.com"
    }
    struct UdacityParameters {
        
        static let UdacityUsername = "username"
        static let UdacityPassword = "password"
        static let UdacitySessionID = "session"
        static let Udacity = "udacity"
    }
    
    
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
    
    struct Constants {
        // Base URLs
        static let UdacityBaseURLSecure: String = "https://www.udacity.com/api"
        static let ParseBaseURLSecure: String = "https://api.parse.com/1/classes/StudentLocation"
        
        // URL Keys
        static let ParseAppID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct Methods {
        // URL Endings
        static let UdacitySession: String = "/session"
        static let FacebookSession: String = "/session"
        static let UdacityData: String = "/users/"
        static let UpdatedAt: String = "?order=-updatedAt"
        static let UpdateLocation: String = "/" + Data.sharedInstance().objectID
    }
    
    struct JsonResponseKeys {
        // Udacity General
        static let Account = "account"
        static let Results = "results"
        static let UserID = "key"
        
        // Udacity User
        static let User = "user"
        static let UserFirstName = "first_name"
        static let UserLastName = "last_name"
        
        // Student Locations
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
}
