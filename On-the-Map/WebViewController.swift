//
//  WebViewController.swift
//  On-the-Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Build the URL
        let url = URL(string: Data.sharedInstance.testLink)!
        let request = URLRequest(url: url)
        
        // Make the request
        webView.loadRequest(request)
    }
    
// MARK: - Actions
    
    // Dismiss the WebView
    @IBAction func dismissWebView(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
