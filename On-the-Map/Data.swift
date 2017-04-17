//
//  Data.swift
//  On-the-Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
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
    
static let sharedInstance = Data()
    
}
