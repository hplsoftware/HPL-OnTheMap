//
//  StudentLocations.swift
//  On the Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocations {
    
    var createdAt = ""
    var firstName = ""
    var lastName = ""
    var latitude = 0.0
    var longitude = 0.0
    var mapString = ""
    var mediaURL = ""
    var objectID = ""
    var uniqueKey = ""
    var updatedAt = ""
    
    //Construct a StudentLocation from a dictionary
    //gaurd statements added to stop errant bad data from being registered
    init?(dictionary: [String:AnyObject]) {
        guard let unique = dictionary[OTMClient.JsonResponseKeys.UniqueKey] as? String else { return nil }
        uniqueKey = unique
        
        guard let created = dictionary[OTMClient.JsonResponseKeys.CreatedAt] as? String else { return nil }
        createdAt = created
        
        guard let first = dictionary[OTMClient.JsonResponseKeys.FirstName] as? String else { return nil }
        firstName = first
        
        guard let last = dictionary[OTMClient.JsonResponseKeys.LastName] as? String else { return nil }
        lastName = last
        
        guard let lat = dictionary[OTMClient.JsonResponseKeys.Latitude] as? Double else { return nil }
        latitude = lat
        
        guard let lon = dictionary[OTMClient.JsonResponseKeys.Longitude] as? Double else { return nil }
        longitude = lon
        
        guard let maps = dictionary[OTMClient.JsonResponseKeys.MapString] as? String else { return nil }
        mapString = maps
        
        guard let media = dictionary[OTMClient.JsonResponseKeys.MediaURL] as? String else { return nil }
        mediaURL = media
        
        guard let obj = dictionary[OTMClient.JsonResponseKeys.ObjectId] as? String else { return nil }
        objectID = obj
        
        guard let upd = dictionary[OTMClient.JsonResponseKeys.UpdatedAt] as? String else { return nil }
        updatedAt = upd
        
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of Student objects */
    static func studLocationInfoFromResults(_ results: [[String:AnyObject]]) -> [StudentLocations] {
        var studLocs = [StudentLocations]()
        for result in results {
            if let studentInf = StudentLocations(dictionary: result) {
                studLocs.append(studentInf)
            }
        }
        return studLocs
    }

}
