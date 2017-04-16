//
//  ListViewController.swift
//  On the Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class ListViewController: UITableViewController {
    
// MARK: - Outlets
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var postButton: UIBarButtonItem!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var closeButton: UIBarButtonItem!
    @IBOutlet var listView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up bar button items.
        if FBSDKAccessToken.current() != nil {
            navigationItem.leftBarButtonItem = closeButton
        } else {
            navigationItem.leftBarButtonItem = logoutButton
        }
        
        self.navigationItem.setRightBarButtonItems([refreshButton, postButton], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Loads tableView data.
        listView.reloadData()
    }
    
    
// MARK: - Actions
    
    // Gets post view controller.
    @IBAction func postUserLocation(_ sender: AnyObject) {
        if Data.sharedInstance().objectID != nil {
            self.displayErrorWithHandler("Location exists.", errorString: "Do you want to update your location or link?")
        } else {
            OTMClient.sharedInstance().getUserData { (success: Bool, error: String) -> Void in
                if success {
                    DispatchQueue.main.async {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "Post View") as! PostViewController
                        
                        self.present(controller, animated: true, completion: nil)
                    }
                } else {
                    self.displayError("Could not handle request.", errorString: error)
                }
            }
        }
    }
    
    // Refreshes student location data.
    @IBAction func refreshLocations(_ sender: AnyObject) {
        self.getStudentLocations()
    }
    
    // Logout of Udacity.
    @IBAction func udacityLogout(_ sender: AnyObject) {
        OTMClient.sharedInstance().udacityLogout { (success: Bool, error: String?) -> Void in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.displayError("Could not log out", errorString: "Please check your network connection and try again.")
            }
        }
    }
    
    // Returns to Login View.
    @IBAction func returnToLoginVC(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: - TableView Methods
    
    // Set up tableView cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "Student List"
        let location = Data.sharedInstance().locations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let firstName = location.firstName
        let lastName = location.lastName
        let mediaURL = location.mediaURL
        
        cell!.textLabel!.text = "\(firstName) \(lastName)"
        cell!.detailTextLabel?.text = mediaURL
        
        cell!.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
    }
    
    // Retrieves number of rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Data.sharedInstance().locations == nil {
            self.getStudentLocations()
        }
        return Data.sharedInstance().locations.count
    }
    
    // Opens URL in browser when row is tapped.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = Data.sharedInstance().locations[(indexPath as NSIndexPath).row]
        let mediaURL = location.mediaURL
        UIApplication.shared.openURL(URL(string: mediaURL)!)
        
    }
    
// MARK: - Additional Methods
    
    // Retrieves student location data.
    func getStudentLocations() {
        OTMClient.sharedInstance().getStudentLocations { locations, errorString in
            if let locations = locations {
                Data.sharedInstance().locations = locations
                DispatchQueue.main.async {
                    self.listView.reloadData()
                }
            } else {
                self.displayError("Error fetching locations", errorString: errorString!)
            }
        }
    }
    
    // Displays error message alert view.
    func displayError(_ title: String, errorString: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: errorString, preferredStyle: .alert)
            let okAction = UIAlertAction (title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Displays error message alert view with completion handler.
    func displayErrorWithHandler(_ title: String, errorString: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: errorString, preferredStyle: .alert)
            let okAction = UIAlertAction (title: "OK", style: UIAlertActionStyle.default) { (action) in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "Post View") as! PostViewController
                
                self.present(controller, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction (title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
