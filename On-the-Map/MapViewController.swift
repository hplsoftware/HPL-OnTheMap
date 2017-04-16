//
//  MapViewController.swift
//  On the Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import UIKit
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
// MARK: - Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var postButton: UIBarButtonItem!
    @IBOutlet var closeButton: UIBarButtonItem!

// MARK: - Variables
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up bar button items.
        navigationItem.leftBarButtonItem = logoutButton
        
        self.navigationItem.setRightBarButtonItems([refreshButton, postButton], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Gets student locations.
        self.getStudentLocations()
        }
    
// MARK: - MKMapViewDelegate
    
    // Creates a view with a "right callout accessory view".
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Opens the pin's URL in browser when tapped.
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.shared
            app.openURL(URL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
    
// MARK: - Actions:
    
    // Gets post view controller
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
        
    // Refresh student location pins.
    @IBAction func refreshMap(_ sender: AnyObject) {
        self.getStudentLocations()
    }
    
    
    // Returns user to Login View.
    @IBAction func returnToLoginVC(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
     // Logs user out of Udacity.
    @IBAction func userLogout(_ sender: AnyObject) {
        if FBSDKAccessToken.current() != nil {
            FBSDKAccessToken.setCurrent(nil)
            self.dismiss(animated: true, completion: nil)
        } else {
            OTMClient.sharedInstance().udacityLogout { (success: Bool, error: String?) -> Void in
                if success {
                self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayError("Could not log out", errorString: "Please check your network connection and try again.")
                }
            }
        }
    }
    
// MARK: - Additional methods
    
    // Gets student location pins.
    func getStudentLocations() {
        OTMClient.sharedInstance().getStudentLocations { locations, errorString -> Void in
            if let locations = locations {
                Data.sharedInstance().locations = locations
                self.displayMap()
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
    
    // Add annotations to the map.
    func displayMap() {
        DispatchQueue.main.async {
            
            for dictionary in Data.sharedInstance().locations {
                
                let lat = CLLocationDegrees(dictionary.latitude as Double)
                let long = CLLocationDegrees(dictionary.longitude as Double)
                
                // Create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName as String
                let last = dictionary.lastName as String
                let mediaURL = dictionary.mediaURL as String
                
                // Create the annotation and set its properties.
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Place the annotation in an array of annotations.
                self.annotations.append(annotation)
            }
            
            // Add the annotations to the map.
            self.mapView.addAnnotations(self.annotations)
        }
    }
}



