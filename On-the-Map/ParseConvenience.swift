//
//  ParseConvenience.swift
//  On-the-Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import Foundation
import UIKit

extension OTMClient {
    
    // Get student location data from Parse.
    func getStudentLocations(_ completionHandler: @escaping (_ result: [StudentLocations]?, _ errorString: String?) -> Void) {
        
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = Constants.ParseBaseURLSecure
        let method = Methods.UpdatedAt
        let key = ""
        
        self.taskForGETMethod(parameters, baseURL: baseURL, method: method, key: key) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(nil, "Please check your network connection, then tap refresh to try again.")
            } else {
                if let results = result?.value(forKey: OTMClient.JsonResponseKeys.Results) as? [[String : AnyObject]] {
                    let studentLocations = StudentLocations.studLocationInfoFromResults(results)
                    completionHandler(studentLocations, "successful")
                } else {
                    completionHandler(nil, "Server error. Please tap refresh to try again.")
                }
            }
        }
    }
    
    // Post location to Parse.
    func postLocation(_ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = Constants.ParseBaseURLSecure
        let method = ""
        let jsonBody: [String: AnyObject] = [
            "uniqueKey": UserDefaults.standard.string(forKey: "UdacityUserID")! as AnyObject,
            "firstName": Data.sharedInstance().userFirstName as AnyObject,
            "lastName": Data.sharedInstance().userLastName as AnyObject,
            "mapString": Data.sharedInstance().mapString as AnyObject,
            "mediaURL": Data.sharedInstance().mediaURL as AnyObject,
            "latitude": Data.sharedInstance().region.center.latitude as AnyObject,
            "longitude": Data.sharedInstance().region.center.longitude as AnyObject
        ]
        
        self.taskForPOSTMethod(parameters, baseURL: baseURL, method: method, jsonBody: jsonBody) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(false, "Please check your network connection and try again.")
            } else {
                if let results = result?.value(forKey: OTMClient.JsonResponseKeys.ObjectId) as? String {
                    Data.sharedInstance().objectID = results
                    completionHandler(true, "successful")
                } else {
                    completionHandler(false, "Please try again.")
                }
            }
        }
    }
    
    // Update posted location in Parse
    func updateLocation(_ completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = Constants.ParseBaseURLSecure
        let method = Methods.UpdateLocation
        let jsonBody: [String: AnyObject] = [
            "uniqueKey": UserDefaults.standard.string(forKey: "UdacityUserID")! as AnyObject,
            "firstName": Data.sharedInstance().userFirstName as AnyObject,
            "lastName": Data.sharedInstance().userLastName as AnyObject,
            "mapString": Data.sharedInstance().mapString as AnyObject,
            "mediaURL": Data.sharedInstance().mediaURL as AnyObject,
            "latitude": Data.sharedInstance().region.center.latitude as AnyObject,
            "longitude": Data.sharedInstance().region.center.longitude as AnyObject
        ]
        
        self.taskForPutMethod(parameters, baseURL: baseURL, method: method, jsonBody: jsonBody) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(false, "Please check your network connection and try again.")
            } else {
                if result?.value(forKey: OTMClient.JsonResponseKeys.UpdatedAt) as? String != nil {
                    completionHandler(true, "successful")
                } else {
                    completionHandler(false, "Please try again.")
                }
            }
        }
    }
}

