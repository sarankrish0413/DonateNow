//
//  SignupDonorViewController.swift
//  DonateNow
//
//  Created by Gayathri Palanisami on 2/6/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import OneSignal
import SkyFloatingLabelTextField

class SignupDonorViewController: UIViewController,signupWebserviceProtocol,UITextFieldDelegate{
    
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPwdTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var restaurantNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var address1TextField: SkyFloatingLabelTextField!
    @IBOutlet weak var address2TextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var pincodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var contactTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var websiteTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    //MARK: Outlets Action
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //Add Button, capture all the details from form and add it to User array
    @IBAction private dynamic func donorRegisterAction(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            OneSignal.idsAvailable({ (userId, token) in
                
                defer {
                    let webSerV: Webservice = Webservice()
                    webSerV.signupDelegate = self
                    webSerV.createNewUser(username: self.emailTextField.text!, password: self.passwordTextField.text!)
                }
                
                guard let token = token, let userId = userId else {
                    return
                }
                oneSignalUserData.userId = userId
                oneSignalUserData.deviceToken = token
            })

        }
        
    }
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        // show navigation controller for Donor page
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        // Status bar black font
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "Welcome New user!!"
        
        //Draw border for register Button
        registerButton.layer.cornerRadius = 19
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.clear.cgColor
        
        //set delegates for text field
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        contactTextField.delegate = self
        confirmPwdTextField.delegate = self
        stateTextField.delegate = self
        cityTextField.delegate = self
        address2TextField.delegate = self
        address1TextField.delegate = self
        restaurantNameTextField.delegate = self
        pincodeTextField.delegate = self
        websiteTextField.delegate = self
        
    }
    
    
    //MARK SignupWebserviceProtocol Methods
    //Signup success push the view controller to Donor Login page
    func signupSuccessful() {
        //Redirect to login page
        let webSerV: Webservice = Webservice()
        webSerV.signupDelegate = self
        webSerV.signupServiceForDonor(firstName: firstNameTextField.text!,lastName: lastNameTextField.text!, email: emailTextField.text!, userType: Utility.selectedUserType!, restaurantName: restaurantNameTextField.text!, orgName: "", address1: address1TextField.text!, address2: address2TextField.text!, city: cityTextField.text!, state: stateTextField.text!, zipcode: pincodeTextField.text!, contact: contactTextField.text!, websiteUrl: websiteTextField.text!, orgId: "", userID: Utility.userID!)
        self.dismiss(animated: true, completion: nil)

    }
    
    //Signup unsuccess Show alert to the user
    func signupUnSuccessful(error: Error) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)

    }
    
    //MARK Keyboard show/hide Methods
    //Show keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == address2TextField || textField == cityTextField || textField == stateTextField || textField == pincodeTextField || textField == contactTextField || textField == websiteTextField {
            self.view.animateViewMoving(up: true, moveValue: 150)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         if textField == address2TextField || textField == cityTextField || textField == stateTextField || textField == pincodeTextField || textField == contactTextField || textField == websiteTextField {
            self.view.animateViewMoving(up: false, moveValue: 150)
        }
    }
    //MARK:Text Field Delegate methods
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
