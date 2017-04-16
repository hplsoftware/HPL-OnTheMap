//
//  PostViewController.swift
//  On-the-Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController, UITextFieldDelegate {
    
// MARK: - Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var section1: UIView!
    @IBOutlet weak var section2: UIView!
    @IBOutlet weak var section3: UIView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
// MARK: - Variables
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0
    
    //Text field delegate objects
    let textDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Set up UI.
        self.mapView.isHidden = true
        self.submitButton.isHidden = true
        self.verifyButton.isHidden = true
        self.linkTextField.isHidden = true
        self.linkLabel.isHidden = true
    
        // Activity indicator
        activityIndicator.hidesWhenStopped = true
        
        //Text field delegates
        self.locationTextField.delegate = textDelegate
        self.linkTextField.delegate = textDelegate
    }

    
// MARK: - Actions

    // Allows user to verify their web link
    @IBAction func verifyLink(_ sender: AnyObject) {
        Data.sharedInstance().testLink = linkTextField.text
        
        let webViewController = self.storyboard!.instantiateViewController(withIdentifier: "WebView") 
        
        present(webViewController, animated: true, completion: nil)
    }
    
    // Locates the address provided by user and adds a pin to the map.
    @IBAction func findLocation(_ sender: AnyObject) {
        Data.sharedInstance().mapString = locationTextField.text
        self.makeTransparent()
        activityIndicator.startAnimating()
        
        let location = locationTextField.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                self.displayError("Could not find location", errorString: "Enter location as City, State, Country or Zipcode.")
                self.activityIndicator.stopAnimating()
                self.returnTransparency()
            } else {
                self.addUserLocation(placemarks!)
                self.activityIndicator.stopAnimating()
                self.returnTransparency()
            }
        } as! CLGeocodeCompletionHandler)
    }
    
    // Posts user location to Parse server.
    @IBAction func postLocation(_ sender: AnyObject) {
        if linkTextField.text!.isEmpty {
            displayError("Link required", errorString: "Please enter a website link to share.")
        } else if Data.sharedInstance().objectID != nil {
            OTMClient.sharedInstance().updateLocation { (success, error) -> Void in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayError("Could not post location", errorString: error!)
                }
            }
        } else {
            Data.sharedInstance().mediaURL = linkTextField.text
            OTMClient.sharedInstance().postLocation { (success, error) -> Void in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayError("Could not post location", errorString: error!)
                }
            }
        }
    }
    
    // Dismiss post view controller
    @IBAction func cancelPost(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    
// MARK: - Additional methods
    
    // Drops pin on the map for user provided location.
    func addUserLocation(_ placemarks: [AnyObject]) {
        
        let placemarks = placemarks as! [CLPlacemark]
        Data.sharedInstance().region = self.setRegion(placemarks)
        self.makeSecondView()
        
        let annotation = MKPointAnnotation()
        let latitude = Data.sharedInstance().region.center.latitude
        let longitude = Data.sharedInstance().region.center.longitude
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
        mapView.setRegion(Data.sharedInstance().region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    // Zooms into the provided location.
    func setRegion(_ placemarks: [CLPlacemark]) -> MKCoordinateRegion? {
        
        var regions = [MKCoordinateRegion]()
        
        for placemark in placemarks {
            
            let coordinate: CLLocationCoordinate2D = placemark.location!.coordinate
            //let latitude: CLLocationDegrees = placemark.location!.coordinate.latitude
            //let longitude: CLLocationDegrees = placemark.location!.coordinate.longitude
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            
            regions.append(MKCoordinateRegion(center: coordinate, span: span))
        }
        
        return regions.first
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

    // Sets up UI after geocoding location.
    func makeSecondView() {
        self.mapView.isHidden = false
        self.submitButton.isHidden = false
        self.verifyButton.isHidden = false
        self.section2.isHidden = true
        self.section3.isHidden = true
        self.studyingLabel.isHidden = true
        self.linkLabel.isHidden = false
        self.linkTextField.isHidden = false
        self.findButton.isHidden = true
        self.section1.backgroundColor = UIColor(red: 0.325, green: 0.318, blue: 0.529, alpha: 1)
    }
    
    // Makes map transparent while geocoding
    func makeTransparent(){
        self.mapView.alpha = 0.5
        submitButton.alpha = 0.5
    }
    
    // Makes map visible when geocoding is complete.
    func returnTransparency() {
        self.mapView.alpha = 1.0
        submitButton.alpha = 1.0
    }
}

// MARK: - Keyboard Methods
extension PostViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
