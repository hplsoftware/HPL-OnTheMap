//
//  StudentInfoArr.swift
//  HPL-OnTheMap
//
//  Created by Rob Sutherland on 2017-04-16.
//  Copyright © 2017 HPL Software. All rights reserved.
//

import MapKit

internal class StudentInfoArr {
    
    internal var array: [StudentInfo] = []
    
    internal var annotations: [MKPointAnnotation] = []
    
    internal var objectId: String = ""
    
    internal func downloadAndStoreData(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void){}
    
    internal class func sharedInstance() -> StudentInfoArr{}
}
