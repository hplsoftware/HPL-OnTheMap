//
//  LoginViewController.swift
//  On the Map
//
//  Created by Rob Sutherland on 4/14/17.
//  Copyright (c) 2017 Rob Sutherland. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {

// Mark: - Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var loadingView: LoadingView!
    
// Mark: - Variables
    var session: URLSession?
    var backgroundGradient: CAGradientLayer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0
    var blurView: UIVisualEffectView?
    
    // Text field delegate objects
    let textDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession.shared
        self.configureUI()
        loadingView.isHidden = true
        
        // Text field delegates
        self.usernameField.delegate = textDelegate
        self.passwordField.delegate = textDelegate
        
        usernameField.text = "rob.s@hplsoftware.com"
        passwordField.text = "Enigma!3138"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
// MARK: - Actions
    
    // Sign up if user does not have an account.
    @IBAction func signUp(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://www.google.com/url?q=https%3A%2F%2Fwww.udacity.com%2Faccount%2Fauth%23!%2Fsignin&sa=D&sntz=1&usg=AFQjCNERmggdSkRb9MFkqAW_5FgChiCxAQ")!)
    }
    
    // Login with Udacity.
    @IBAction func userLogin(_ sender: AnyObject) {
        if usernameField.text!.isEmpty {
            debugLabel.text = "Please enter your email."
        } else if passwordField.text!.isEmpty {
            debugLabel.text = "Please enter your password."
        } else {
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
            self.blurLoading()
            loadingView.isHidden = false
            loadingView.animateProgressView()
            OTMClient.sharedInstance().udacityLogin(usernameField.text!, password: passwordField.text!, completionHandler: { (success, errorString) -> Void in
                if success {
                    DispatchQueue.main.async(execute: {
                        self.loadingView.isHidden = true
                        self.blurView?.removeFromSuperview()
                        self.completeLogin()
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                    self.loadingView.isHidden = true
                    self.blurView?.removeFromSuperview()
                    self.displayError(errorString!)
                    })
                }
            })
        }
    }
    
//    // Login using Facebook.
//    @IBAction func facebookLogin(_ sender: AnyObject) {
//        let fbLoginManager = FBSDKLoginManager()
//        fbLoginManager.logIn(withReadPermissions: ["email"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
//            self.debugLabel.text = ""
//            if error != nil {
//                self.viewWillAppear(true)
//            } else if result.isCancelled {
//                self.viewWillAppear(true)
//            } else {
//                self.blurLoading()
//                UserDefaults.standard.set(FBSDKAccessToken.current().tokenString!, forKey: "FBAccessToken")
//                OTMClient.sharedInstance().loginWithFacebook { success, errorString in
//                    if success {
//                        DispatchQueue.main.async(execute: {
//                            self.loadingView.isHidden = true
//                            self.blurView?.removeFromSuperview()
//                            self.completeLogin()
//                        })
//                    } else {
//                        DispatchQueue.main.async(execute: {
//                            self.loadingView.isHidden = true
//                            self.blurView?.removeFromSuperview()
//                            self.displayError(errorString!)
//                        })
//                    }
//                }
//            }
//        })
//    }
//    

// MARK: - Additional methods
    
    // Clears text fields and gets MapViewController.
    func completeLogin() {
            self.usernameField.text = ""
            self.passwordField.text = ""
            self.getTabController()
    }
    
    // Gets MapViewController.
    func getTabController() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapTabBarController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    
    // Error alert notification.
    func displayError(_ errorString: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Could not log in.", message: errorString, preferredStyle: .alert)
            let okAction = UIAlertAction (title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Blur background while login is loading
    func blurLoading() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView!.frame = self.view.bounds
            self.view.insertSubview(blurView!, belowSubview: loadingView)
        } else {
            self.view.backgroundColor = UIColor.black
        }
    }
}

// Mark: - Configure UI
extension LoginViewController {
    func configureUI() {
        
        // Configure background gradient
        self.view.backgroundColor = UIColor.clear
        let colorTop = UIColor(red: 0.973, green: 0.514, blue: 0.055, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.965, green: 0.353, blue: 0.027, alpha: 1.0).cgColor
        self.backgroundGradient = CAGradientLayer()
        self.backgroundGradient!.colors = [colorTop, colorBottom]
        self.backgroundGradient!.locations = [0.0, 1.0]
        self.backgroundGradient!.frame = view.frame
        self.view.layer.insertSublayer(self.backgroundGradient!, at: 0)}
}

// Mark: - Keyboard Methods
extension LoginViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
