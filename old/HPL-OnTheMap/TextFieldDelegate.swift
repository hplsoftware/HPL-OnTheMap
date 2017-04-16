//
//  TextFieldDelegate.swift
//  HPL-OnTheMap
//
//  Created by Rob Sutherland on 2017-04-16.
//  Copyright © 2017 HPL Software. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // Dismisses keyboard when user taps "return".
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}

