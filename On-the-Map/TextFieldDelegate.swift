//
//  TextFieldDelegate.swift
//  On-the-Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // Dismisses keyboard when user taps "return".
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
