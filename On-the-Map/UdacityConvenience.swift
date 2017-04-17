//
//  UdacityConvenience.swift
//  On-the-Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import Foundation
import UIKit

extension OTMClient {
    
    // Login to Udacity and get User Id.
    func udacityLogin(_ username: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = Constants.UdacityBaseURLSecure
        let method = Methods.UdacitySession
        let jsonBody = ["udacity": ["username": username, "password" : password]]
        
        // Make the request
        self.taskForPOSTMethod(parameters, baseURL: baseURL, method: method, jsonBody: jsonBody as [String : AnyObject]) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(false, "Please check your network connection and try again.")
            } else {
                if let resultDictionary = result?.value(forKey: OTMClient.JsonResponseKeys.Account) as? NSDictionary {
                    if let userID = resultDictionary.value(forKey: OTMClient.JsonResponseKeys.UserID) as? String {
                        UserDefaults.standard.set(userID, forKey: "UdacityUserID")
                        completionHandler(true, "successful")
                    }
                } else {
                    completionHandler(false, "Username or password is incorrect.")
                    print("Could not find \(JsonResponseKeys.Account) in \(result)")
                }
            }
        }
    }
    
    // Login to Udacity using Facebook credentials.
    func loginWithFacebook(_ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = Constants.UdacityBaseURLSecure
        let method = Methods.UdacitySession
        let jsonBody = ["facebook_mobile": ["access_token": UserDefaults.standard.string(forKey: "FBAccessToken")!]]
        
        // Make the request
        self.taskForPOSTMethod(parameters, baseURL: baseURL, method: method, jsonBody: jsonBody as [String : AnyObject]) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(false, "Please check you network connection and try again.")
            } else {
                if let resultDictionary = result?.value(forKey: OTMClient.JsonResponseKeys.Account) as? NSDictionary {
                    if let userID = resultDictionary.value(forKey: OTMClient.JsonResponseKeys.UserID) as? String {
                        UserDefaults.standard.set(userID, forKey: "UdacityUserID")
                        completionHandler(true, "successful")
                    }
                } else {
                    completionHandler(false, "Server error: Please try again.")
                }
            }
        }
    }
    
    // Get user's public data from Udacity.
    func getUserData(_ completionHandler: @escaping (_ success: Bool, _ error: String) -> Void) {
        
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = Constants.UdacityBaseURLSecure
        let method = Methods.UdacityData
        let key = UserDefaults.standard.string(forKey: "UdacityUserID")!
        
        // Make the request
        self.taskForGETMethod(parameters, baseURL: baseURL, method: method, key: key) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(false, "Please check your network connection and try again.")
            } else {
                if let userDictionary = result?.value(forKey: OTMClient.JsonResponseKeys.User) as? NSDictionary {
                    if let firstName = userDictionary.value(forKey: OTMClient.JsonResponseKeys.UserFirstName) as? String {
                        Data.sharedInstance.userFirstName = firstName
                        if let lastName = userDictionary.value(forKey: OTMClient.JsonResponseKeys.UserLastName) as? String {
                            Data.sharedInstance.userLastName = lastName
                            completionHandler(true, "successful")
                        }
                    }
                } else {
                    completionHandler(false, "Server error. Please try again.")
                }
            }
        }
    }
    
    // Logout of Udacity.
    func udacityLogout(_ completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // Build the URL and configure the request
        let method = Methods.UdacitySession
        var request = URLRequest(url: URL(string: OTMClient.Constants.UdacityBaseURLSecure + method)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // Make the request
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            // Send the desired value(s) to completion handler
            if error != nil {
                completionHandler(false, "Could not logout.")
                return
            }
            let range = Range(5..<data!.count)
            let _ = data!.subdata(in: range)
            completionHandler(true, nil)
        }) 
        task.resume()
    }

}
