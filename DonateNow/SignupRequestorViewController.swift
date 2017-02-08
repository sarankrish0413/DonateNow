//
//  SignupRequestorViewController.swift
//  DonateNow
//
//  Created by Gayathri Palanisami on 2/6/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignupRequestorViewController: UIViewController{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var userTypeTextField: UITextField!
    @IBOutlet weak var orgNameTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var orgIdTextField: UITextField!
    
    
    @IBAction func requestorRegisterAction(_ sender: UIButton) {
        print("when register button is pressed")
        let uuid = UUID().uuidString
        print(uuid)
        
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            addRequestorDetailsToFireBaseDatabase(username: usernameTextField.text!, email: emailTextField.text!, userType: userTypeTextField.text!, restaurantName: "", orgName: orgNameTextField.text!, address1: address1TextField.text!, address2: address2TextField.text!, city: cityTextField.text!, state: stateTextField.text!, zipcode: pincodeTextField.text!, contact: contactTextField.text!, websiteUrl: "", orgId: orgIdTextField.text!, userID: uuid)
            
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    //Redirect to login page
                    let loginViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
                    self.navigationController?.pushViewController(loginViewControllerObj!, animated: true)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        
        
        
        
    }
    
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        // show navigation controller for Donor page
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:true);
        let logoutButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style:
            UIBarButtonItemStyle.plain, target: self, action: Selector(("Logout")))
        self.navigationItem.rightBarButtonItem = logoutButton;
        // Status bar black font
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "Welcome testuser!!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addRequestorDetailsToFireBaseDatabase(username:String, email:String, userType:String, restaurantName: String, orgName: String, address1: String, address2: String, city: String, state: String, zipcode: String, contact:String, websiteUrl: String, orgId: String, userID: String){
        
        let ref = FIRDatabase.database().reference(withPath: "Users")
        let user = User(username: username, email: email, userType: userType, restaurantName: restaurantName, orgName: orgName, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode,contact: contact, weburl: websiteUrl, orgId: orgId, userID: userID)
        let userRef = ref.child(userID.lowercased())
        userRef.setValue(user.toAnyObject())
        
        
    }
}
