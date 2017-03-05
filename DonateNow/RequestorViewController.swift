//
//  RequestorViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/5/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit

class RequestorViewController: UITabBarController,logoutServiceProtocol{
    
  
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //show navigation controller for Donor page
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:true)

       let logoutButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout") ,style: UIBarButtonItemStyle.plain, target: self,action: #selector(LogoutAction))
        logoutButton.tintColor = UIColor.white

        self.navigationItem.rightBarButtonItem = logoutButton
        
        // Status bar black font
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let charityNameString = "Welcome " + Utility.charityName! + "!!"
        self.title = charityNameString
    }
    
    func LogoutAction() {
        
        let webSerV: Webservice = Webservice()
        webSerV.logoutDelegate = self
        webSerV.logoutService()
    }
    
    //Mark Logout Protocol methods
    func logoutSuccessful(){
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    func logoutUnSuccessful(error:Error){
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
}
