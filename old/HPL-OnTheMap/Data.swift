//
//  Data.swift
//  HPL-OnTheMap
//
//  Created by Rob Sutherland on 2017-04-16.
//  Copyright © 2017 HPL Software. All rights reserved.
//

import UIKit
import MapKit

class Data: NSObject {
    
    // Data for posting user location
    var userFirstName: String!
    var userLastName: String!
    var mapString: String!
    var mediaURL: String!
    var region: MKCoordinateRegion!
    
    // Data for testing mediaURL
    var testLink: String!
    
    // Data for updating user location
    var objectID: String!
    
    // Student locations array
    var locations: [StudentLocations]!
    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> Data {
        
        struct Singleton {
            static var sharedInstance = Data()
        }
        
        return Singleton.sharedInstance
    }
}
