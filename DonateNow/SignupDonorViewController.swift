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

class SignupDonorViewController: UIViewController,signupWebserviceProtocol,logoutServiceProtocol{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var userTypeTextField: UITextField!
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    //MARK: Outlets Action
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
       let logoutButton:UIBarButtonItem = UIBarButtonItem(title: "Logout",style: UIBarButtonItemStyle.plain, target: self,action: #selector(LogoutAction))
        self.navigationItem.rightBarButtonItem = logoutButton;
        // Status bar black font
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "Welcome New user!!"
        self.userTypeTextField.text = Utility.DONOR
    }
    
    func LogoutAction() {
        
        let webSerV: Webservice = Webservice()
        webSerV.logoutDelegate = self
        webSerV.logoutService()
    }
    
    
    //Mark Logout Protocol methods
    func logoutSuccessful(){
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    func logoutUnSuccessful(error:Error){
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    //MARK SignupWebserviceProtocol Methods

    //Signup success push the view controller to Donor Login page
    func signupSuccessful() {
        //Redirect to login page
        let webSerV: Webservice = Webservice()
        webSerV.signupDelegate = self
        webSerV.signupServiceForDonor(username: usernameTextField.text!, email: emailTextField.text!, userType: userTypeTextField.text!, restaurantName: restaurantNameTextField.text!, orgName: "", address1: address1TextField.text!, address2: address2TextField.text!, city: cityTextField.text!, state: stateTextField.text!, zipcode: pincodeTextField.text!, contact: contactTextField.text!, websiteUrl: websiteTextField.text!, orgId: "", userID: Utility.userID!)
        let loginViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.navigationController?.pushViewController(loginViewControllerObj!, animated: true)
    }
    
    //Signup unsuccess Show alert to the user
    func signupUnSuccessful(error: Error) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
