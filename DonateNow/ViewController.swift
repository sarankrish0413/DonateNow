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


class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    
    //MARK: Outlets Action
    //Based on the User Type set selected index for segmented control 0 - Donor 1 - Requestor
    @IBAction func userTypeSegmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            userTypeSegmentedControl.selectedSegmentIndex = 0
        } else {
            userTypeSegmentedControl.selectedSegmentIndex = 1
        }
        
    }
    
    // Sign up action
    
    @IBAction func signUpAction(_ sender: UIButton) {
       
        if(userTypeSegmentedControl.selectedSegmentIndex == 0){
            //Donor
            let donorSignUpViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignupDonorViewController") as? SignupDonorViewController
            self.navigationController?.pushViewController(donorSignUpViewControllerObj!, animated: true)
        }
        else if(userTypeSegmentedControl.selectedSegmentIndex == 1){
            //Requestor
            let requestorSignUpViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignupRequestorViewController") as? SignupRequestorViewController
            self.navigationController?.pushViewController(requestorSignUpViewControllerObj!, animated: true)
        }
    }
    //Login Button action
    @IBAction func loginAction(_ sender: UIButton) {
        if(userTypeSegmentedControl.selectedSegmentIndex == 0){
            FIRAuth.auth()?.signIn(withEmail: self.userNameTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    //Show Donor
                                let donorViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DonorViewController") as? DonorViewController
                                self.navigationController?.pushViewController(donorViewControllerObj!, animated: true)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
        else if(userTypeSegmentedControl.selectedSegmentIndex == 1){
            //Requestor
            let requestorViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RequestorViewController") as? RequestorViewController
            self.navigationController?.pushViewController(requestorViewControllerObj!, animated: true)
        }
    }
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Hide navigation controller for login page
        self.navigationController?.isNavigationBarHidden = true
        
        //Set Selected Index as Donor
        userTypeSegmentedControl.selectedSegmentIndex = 0;
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

