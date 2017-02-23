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

class ViewController: UIViewController,loginWebserviceProtocol,UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
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
            let donorSignUpViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignupDonorViewController") as? SignupDonorViewController
            //self.navigationController?.pushViewController(donorSignUpViewControllerObj!, animated: true)
            self.navigationController?.present(donorSignUpViewControllerObj!, animated: true, completion: nil)

            
        }
        else if(userTypeSegmentedControl.selectedSegmentIndex == 1){
            //Requestor
            let requestorSignUpViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignupRequestorViewController") as? SignupRequestorViewController
            //self.navigationController?.pushViewController(requestorSignUpViewControllerObj!, animated: true)
            self.navigationController?.present(requestorSignUpViewControllerObj!, animated: true, completion: nil)

        }
    }
    //Login Button action
    @IBAction func loginAction(_ sender: UIButton) {
        activityIndicator.startAnimating()
        let webSerV: Webservice = Webservice()
        webSerV.loginDelegate = self
        webSerV.loginService(username: self.userNameTextField.text!,password: self.passwordTextField.text!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Set Selected Index as Donor
        userTypeSegmentedControl.selectedSegmentIndex = 0;
        Utility.selectedUserType = Utility.DONOR
        //show activity inidcator view
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
        self.view.addSubview(activityIndicator)
//        //Show hide Keyboard
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        //set delegates for text field
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        //Draw border for Sign in Button
        loginButton.layer.cornerRadius = 19 //  0.08 * loginButton.bounds.size.width
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        
        //Draw border for facebook Button
        facebookLoginButton.layer.cornerRadius = 19
        facebookLoginButton.layer.borderWidth = 1
        facebookLoginButton.layer.borderColor = UIColor.clear.cgColor
        
        //Draw border for Google Button
        googleLoginButton.layer.cornerRadius = 19
        googleLoginButton.layer.borderWidth = 1
        googleLoginButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    //MARK WebserviceProtocol Methods
    //Login success push the view controller to Donor home page or Requstor home page based on user type
    func loginSuccessful() {
        activityIndicator.stopAnimating()
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
        userNameTextField.text = ""
        passwordTextField.text = ""
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
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

