//
//  ViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 1/26/17.
// Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import OneSignal
import SkyFloatingLabelTextField
import FirebaseAnalytics


class ViewController: UIViewController,loginWebserviceProtocol,UITextFieldDelegate, forgotPasswordProtocol {
    
    //MARK: Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signupButton: UIButton!
    var activityIndicator:UIActivityIndicatorView!
    
    
    //MARK: Outlets Action
    //Based on the User Type set selected index for segmented control 0 - Donor 1 - Requestor
    @IBAction func userTypeSegmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            userTypeSegmentedControl.selectedSegmentIndex = 0
            Utility.selectedUserType = Utility.DONOR
        } else {
            userTypeSegmentedControl.selectedSegmentIndex = 1
            Utility.selectedUserType = Utility.REQUESTOR
        }
        
    }
    
    // Sign up action
    @IBAction func signUpAction(_ sender: UIButton) {
        if(userTypeSegmentedControl.selectedSegmentIndex == 0){
            //Donor
            if let donorSignUpViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignupDonorViewController") as? SignupDonorViewController {
                self.navigationController?.present(donorSignUpViewControllerObj, animated: true, completion: nil)
            }
        }
        else if(userTypeSegmentedControl.selectedSegmentIndex == 1){
            //Requestor
            if let requestorSignUpViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignupRequestorViewController") as? SignupRequestorViewController {
                self.navigationController?.present(requestorSignUpViewControllerObj, animated: true, completion: nil)
            }
        }
    }
    //Login Button action
    @IBAction func loginAction(_ sender: UIButton) {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        let webSerV: Webservice = Webservice()
        webSerV.loginDelegate = self
        webSerV.loginService(username: self.userNameTextField.text!,password: self.passwordTextField.text!)
    }
    
    //Forgot password Action
    @IBAction func forgotPasswordAction(_ sender: Any) {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        let webSerV: Webservice = Webservice()
        webSerV.forgotPasswordDelegate = self
        if userNameTextField.text == "" {
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = true
            let alertController = UIAlertController(title: "Error", message: "Please enter your emailID", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            webSerV.forgotPassword(emailID: self.userNameTextField.text!)
        }
    }
    
   
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Set Selected Index as Donor
        userTypeSegmentedControl.selectedSegmentIndex = 0
        Utility.selectedUserType = Utility.DONOR
        //show activity inidcator view
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
        //set delegates for text field
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        //Draw border for Sign in Button
        loginButton.layer.cornerRadius = 19
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor

       
    }
    
 
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK WebserviceProtocol Methods
    //Login success push the view controller to Donor home page or Requstor home page based on user type
    func loginSuccessful() {
        //Firebase Analytics
        FIRAnalytics.logEvent(withName: "login", parameters: [
            "userID": Utility.userID! as String as NSObject,
            ])
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        userNameTextField.text = ""
        passwordTextField.text = ""
        OneSignal.idsAvailable({ (userId, token) in
            guard let token = token, let userId = userId else {
                return
            }
            oneSignalUserData.userId = userId
            oneSignalUserData.deviceToken = token
        })
        
        if(userTypeSegmentedControl.selectedSegmentIndex == 0 && Utility.userType == Utility.selectedUserType){
            //Show Donor
            let donorViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DonorViewController") as? DonorViewController
            self.navigationController?.pushViewController(donorViewControllerObj!, animated: true)
            
        }
        else if(userTypeSegmentedControl.selectedSegmentIndex == 1 && Utility.userType == Utility.selectedUserType){
            //Requestor
            let requestorViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RequestorViewController") as? RequestorViewController
            self.navigationController?.pushViewController(requestorViewControllerObj!, animated: true)
        }
            
        else{
            let alertController = UIAlertController(title: "Error", message:"Please select your user type correctly", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //Login unsuccess Show alert to the user
    func loginUnSuccessful(error:Error) {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        userNameTextField.text = ""
        passwordTextField.text = ""
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK:ForgotPassword Protocol methods
    func forgotPasswordSuccessful() {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        let alertController = UIAlertController(title: "Error", message: "Please check your email to change your password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func forgotPasswordUnSuccessful(error:Error) {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK Keyboard show/hide Methods
    //Show keyboard
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    //Hide Keyboard
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    //MARK:Text Field Delegate methods
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

