//
//  StudentInfo.swift
//  HPL-OnTheMap
//
//  Created by Rob Sutherland on 2017-04-16.
//  Copyright © 2017 HPL Software. All rights reserved.
//

import MapKit

internal struct StudentInfo {
    
    internal var lat: CLLocationDegrees
    
    internal var long: CLLocationDegrees
    
    internal var firstName: String
    
    internal var lastName: String
    
    internal var mediaURL: String
    
    internal var mapString: String?
    
    internal var uniqueKey: String
    
    internal var objectId: String?
    
    internal init?(dictionary: [String : AnyObject]){}
    
    internal init(lat: CLLocationDegrees, long: CLLocationDegrees, firstName: String, lastName: String, mediaURL: String, mapString: String, uniqueKey: String){}
    
    internal static func studentInformationFromResults(_ results: [[String : AnyObject]]) -> [StudentInfo]{}
    
    internal static func annotationsFromStudentInformation(_ students: [StudentInfo]) -> [MKPointAnnotation]{}
}
