//
//  OTMClient.swift
//  On the Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import Foundation
import UIKit

class OTMClient : NSObject {
    
    // Shared session
    var session: URLSession
    
    override init() {
        session = URLSession.shared
        super.init()
    }
    
// MARK: - Methods
    
    // Get type network call.
    func taskForGETMethod(_ parameters: [String : AnyObject], baseURL: String, method: String, key: String, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 2/3. Build the URL and configure the request
        let urlString = baseURL + method + key
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        if baseURL == Constants.ParseBaseURLSecure {
            let parseID = Constants.ParseAppID
            let parseKey = Constants.ParseAPIKey
            
            request.addValue(parseID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(parseKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        // 4. Make the request
        let task = session.dataTask(with: request, completionHandler: {data, response, downloadError in
            
            // 5/6. Parse the data and use the data (happens in completion handler)
            if downloadError != nil {
                completionHandler(nil, downloadError as NSError?)
            } else {
                let newData : Foundation.Data?
                if baseURL == Constants.UdacityBaseURLSecure {
                    let range = Range(5..<data!.count)
                    newData = data!.subdata(in: range)
                } else {
                    newData = data
                }
                OTMClient.parseJSONWithCompletionHandler(newData!, completionHandler: completionHandler)
            }
        }) 
        
        // 7. Start the request
        task.resume()
        
        return task
    }

    // Post type network call.
    func taskForPOSTMethod(_ parameters: [String: AnyObject], baseURL: String, method: String, jsonBody: [String: AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 1. Set the parameters
        let parameters = [String: AnyObject]()
        
        // 2. Build the URL
        let urlString = baseURL + method + OTMClient.escapedParameters(parameters)
        let url = URL(string: urlString)!
        
        // 3. Configure the request
        var request = URLRequest(url: url)
        
        if baseURL == Constants.ParseBaseURLSecure {
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            } catch {
                request.httpBody = nil
            }
        } else {
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            } catch {
                request.httpBody = nil
            }
        }
        
        // 4. Make the request
        let task = session.dataTask(with: request, completionHandler: {data, response, downloadError in
            // 5/6. Parse the data and use the data (happens in completion handler)
            if let _ = downloadError {
                completionHandler(nil, downloadError as NSError?)
            } else {
                let newData : Foundation.Data?
                if baseURL == Constants.UdacityBaseURLSecure {
                    let range = Range(5..<data!.count)
                    newData = data!.subdata(in: range)
                } else {
                    newData = data
                }
                OTMClient.parseJSONWithCompletionHandler(newData!, completionHandler: completionHandler)
            }
        }) 
        
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    func taskForPutMethod(_ parameters: [String: AnyObject], baseURL: String, method: String, jsonBody: [String: AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 1. Set the parameters
        let parameters = [String: AnyObject]()
        
        // 2. Build the URL
        let urlString = baseURL + method + OTMClient.escapedParameters(parameters)
        let url = URL(string: urlString)!
        
        // 3. Configure the request
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
        } catch {
            request.httpBody = nil
        }
        
        // 4. Make the request
        let task = session.dataTask(with: request, completionHandler: {data, response, downloadError in
            // 5/6. Parse the data and use the data (happens in completion handler)
            if let _ = downloadError {
                completionHandler(nil, downloadError as NSError?)
            } else {
                OTMClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }) 
        
        // 7. Start the request
        task.resume()
        
        return task
        
    }
    
        
// MARK: - Helpers
    
    // Helper function: Given a dictionary of parameters, convert to a string for a url
    class func escapedParameters(_ parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            // Make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            // Append it
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }
    
    // Helper: Given raw JSON, return a usable Foundation object
    class func parseJSONWithCompletionHandler(_ data: Foundation.Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let parsingError: NSError? = nil
        
        let parsedResult = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)as? NSDictionary
        
        if let _ = parsingError {
            completionHandler(nil, parsingError)
            print(parsingError)
        } else {
            //println(parsedResult)
            completionHandler(parsedResult as! [String: AnyObject] as AnyObject?, nil)
        }
    }
    
    // Helper: Substitute the key for the value that is contained within the method name
    class func subtituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
// MARK: - Shared Instance
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
}

