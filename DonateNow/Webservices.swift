//
//  Webservices.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/13/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import OneSignal

//Login service Protocol
protocol loginWebserviceProtocol {
    func loginSuccessful()
    func loginUnSuccessful(error:Error)
}

//Signup service Protocol
protocol signupWebserviceProtocol {
    func signupSuccessful()
    func signupUnSuccessful(error:Error)
}

//Logout service protocol
protocol logoutServiceProtocol {
    func logoutSuccessful()
    func logoutUnSuccessful(error:Error)
    
}

//New Donations service Protocol
protocol newDonationProtocol{
    func newDonationSuccessful()
    func newDonationUnSuccessful(error:Error)
}

//View List of donations based on user logged in
protocol viewNewDonationProtocol {
    func viewNewDonationsSuccessful(items:[Donation])
    func viewNewDonationUnSuccessful(items:[Donation])
}

//view Donation details
protocol viewDonationDetailsProtocol {
    func viewDonationDetailsSuccessful(itemsDict:Dictionary<String, Any>)
    func viewDonationDetailsUnSuccessful()
}

//update Donation details
protocol updateDonationDetailsProtocol{
    func updateDonationSuccessful()
    func updateDonationUnSuccessful(error:Error)
}

//View available donations requestor
protocol viewAvailableDonationsProtocol{
    func viewAvailableDonationSuccessful(items:[Donation])
    func viewAvailableDonationUnSuccessful(items:[Donation])
}

//Reserve for Available Donations
protocol reserveAvailableDonationsProtocol {
    func reserveAvailableDonationSuccessful(status:String)
    func reserveAvailableUnSuccessful(error:Error)
}
//View accepted donations requestor
protocol viewAcceptedDonationsProtocol{
    func viewAcceptedDonationSuccessful(items:[Donation])
    func viewAcceptedDonationUnSuccessful(items:[Donation])
}

//View Pending Approval donations requestor
protocol viewPendingApprovalDonationsProtocol{
    func viewPendingApprovalDonationSuccessful(items:[Donation])
    func viewPendingApprovalDonationUnSuccessful(items:[Donation])
}




class Webservice {
    //TODO: Change delegates to closures
    var loginDelegate:loginWebserviceProtocol?
    var signupDelegate:signupWebserviceProtocol?
    var logoutDelegate:logoutServiceProtocol?
    var newDonationDelegate:newDonationProtocol?
    var viewNewDonationDelegate:viewNewDonationProtocol?
    var viewDonationDetailsDelegate:viewDonationDetailsProtocol?
    var updateDonationsDelegate:updateDonationDetailsProtocol?
    var viewAvailableDonationsDelegate:viewAvailableDonationsProtocol?
    var reserveAvailableDonationsDelegate:reserveAvailableDonationsProtocol?
    var viewAcceptedDonationsDelegate:viewAcceptedDonationsProtocol?
    var PendingApprovalDonationsDelegate:viewPendingApprovalDonationsProtocol?
    
    //MARK:Login related Service
    //Invoke firebase login service
    func loginService(username:String,password:String) {
        FIRAuth.auth()?.signIn(withEmail: username, password: password) { (user, error) in
            
            guard let user = user else {
                if let error = error  {
                    self.loginDelegate?.loginUnSuccessful(error: error)
                }
                return
            }
            
            Utility.userID = user.uid
            Utility.userName = user.email
            self.getUserDetails()
            debugPrint("uudi:",user.uid)
        }
    }
    
    //MARK:Signup related Service
    //Invoke firebase signup service For Donor
    func signupServiceForDonor(username:String, email:String, userType:String, restaurantName: String, orgName: String, address1: String, address2: String, city: String, state: String, zipcode: String, contact:String, websiteUrl: String, orgId: String, userID: String){
        let ref = FIRDatabase.database().reference(withPath: "Users")
        var user = User(username: username, email: email, userType: userType, restaurantName: restaurantName, orgName: orgName, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode,contact: contact, weburl: websiteUrl, orgId: orgId, userID: userID)
        if let signalId = oneSignalUserData.userId {
            user.oneSignalIds.append(signalId)
        }
        let userRef = ref.child(userID)
        userRef.setValue(user.toAnyObject())
    }
    
    //Invoke firebase signup service For Requestor
    func signupServiceForRequestor(username:String, email:String, userType:String, restaurantName: String, orgName: String, address1: String, address2: String, city: String, state: String, zipcode: String, contact:String, websiteUrl: String, orgId: String, userID: String){
        let ref = FIRDatabase.database().reference(withPath: "Users")
        var user = User(username: username, email: email, userType: userType, restaurantName: restaurantName, orgName: orgName, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode,contact: contact, weburl: websiteUrl, orgId: orgId, userID: userID)
        if let signalId = oneSignalUserData.userId {
            user.oneSignalIds.append(signalId)
        }
        let userRef = ref.child(userID)
        userRef.setValue(user.toAnyObject())
    }
    
    //Invoke firebase service for logout
    func logoutService() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            self.logoutDelegate?.logoutSuccessful()
            Utility.userID = ""
            Utility.userName = ""
            Utility.userType = ""
            Utility.restaurantName = ""
        } catch  let signOutError as NSError {
            debugPrint ("Error signing out: %@", signOutError)
            self.logoutDelegate?.logoutUnSuccessful(error: signOutError)
        }
       
    }
    
    //Invoke firebase create user service
    func createNewUser(username:String, password:String){
        FIRAuth.auth()?.createUser(withEmail: username, password: password) { (user, error) in
            //TODO: use guard here for user, else error out
            if error == nil {
                Utility.userID = user!.uid
                Utility.userName = user!.email
                self.signupDelegate?.signupSuccessful()
                
            } else {
                self.signupDelegate?.signupUnSuccessful(error: error!)
                
            }
        }
    }
    
    //MARK:New Donation
    //Add Data to Firebase Database
    func addDonationDetailsToFireBaseDatabase(foodDesc:String, quantity:String, contact:String, address1:String, address2: String, city:String, state: String, zipcode:String, splInstructions:String, createdUserID:String, createdDate:String, pickUpFromDate:String, pickUpToDate:String, donationID:String, donationStatus:String,donationTitle:String,restaurantName:String,requestorUserID: String){
        
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        var donation = Donation(foodDesc: foodDesc,quantity: quantity,contact: contact,address1: address1,address2: address2,city: city,state: state,zipcode: zipcode,splInstructions: splInstructions,createdUserID: createdUserID,createdDate: createdDate,pickUpFromDate: pickUpFromDate ,pickUpToDate: pickUpToDate,donationID: donationID,donationStatus: donationStatus,donationTitle: donationTitle,restaurantName:restaurantName,requestorUserID:requestorUserID)
        if let signalId = oneSignalUserData.userId {
            donation.signalIds.append(signalId)
        }
        donation.requestorSignalIds = [String]()
        let donationItemRef = ref.child(donationID)
        donationItemRef.setValue(donation.toAnyObject()){ (error, ref) -> Void in
            if error == nil{
                self.newDonationDelegate?.newDonationSuccessful()
                
            }else{
                self.newDonationDelegate?.newDonationUnSuccessful(error: error!)
            }
            
        }
    }
    
    //MARK:Retrive Donation
    //view Donation  from Firebase Database
    func ViewNewDonationDetails(){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "createdUserID").queryEqual(toValue: Utility.userID).observe(.value, with: { (snapshot) in
            var newItems = [Donation]()
            if !snapshot.exists() {
                self.viewNewDonationDelegate?.viewNewDonationUnSuccessful(items: newItems)
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    newItems.append(donationItem)
                }
                self.viewNewDonationDelegate?.viewNewDonationsSuccessful(items: newItems)
            }
        })
    }
    
    //MARK:Retrive Donation Details
    //view Donation details from Firebase Database
    func ViewDonationDetails(donationID:String){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "donationID").queryEqual(toValue: donationID).observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                self.viewDonationDetailsDelegate?.viewDonationDetailsUnSuccessful()
            }
            else {
                let snapDict = snapshot.value as? [String:AnyObject]
                self.viewDonationDetailsDelegate?.viewDonationDetailsSuccessful(itemsDict: snapDict!)
            }
        })
    }
    
    //MARK:Update Donation Details
    //view Update Donation details in Firebase Database
    func updateDonationDetailsToFireBaseDatabase(foodDesc:String, quantity:String, contact:String, address1:String, address2: String, city:String, state: String, zipcode:String, splInstructions:String,pickUpFromDate:String, pickUpToDate:String, donationID:String,donationTitle:String){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        let donationItemRef = ref.child(donationID)
        donationItemRef.updateChildValues(
            ["foodDesc" : foodDesc,
             "quantity" : quantity,
             "pickUpFromDate" : pickUpFromDate,
             "pickUpToDate" : pickUpToDate,
             "contact" : contact,
             "address1" : address1,
             "address2" : address2,
             "city" : city,
             "state" : state,
             "zipcode" : zipcode,
             "splInstructions" : splInstructions,
             "donationID" : donationID,
             "donationTitle":donationTitle]
        ){ (error, ref) -> Void in
            if error == nil{
                self.updateDonationsDelegate?.updateDonationSuccessful()
                
            }else{
                self.updateDonationsDelegate?.updateDonationUnSuccessful(error: error!)
            }
            
        }
        
    }
    
    //MARK:View Available Donation for Requestor
    func ViewAvailableDonations(){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "donationStatus").queryEqual(toValue: Utility.NEW).observe(.value, with: { (snapshot) in
            var newItems = [Donation]()
            if !snapshot.exists() {
                self.viewAvailableDonationsDelegate?.viewAvailableDonationUnSuccessful(items: newItems)
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    newItems.append(donationItem)
                }
                self.viewAvailableDonationsDelegate?.viewAvailableDonationSuccessful(items: newItems)
            }
        })
    }
    
    //MARK:View Accepted Donation for Requestor
    func ViewAcceptedDonations(){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "donationStatus").queryEqual(toValue:Utility.ACCEPTED).observe(.value, with: { (snapshot) in
            var newItems = [Donation]()
            if !snapshot.exists() {
                self.viewAcceptedDonationsDelegate?.viewAcceptedDonationUnSuccessful(items: newItems)
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    if donationItem.requestorUserID == Utility.userID {
                        newItems.append(donationItem)
                    }
                }
                self.viewAcceptedDonationsDelegate?.viewAcceptedDonationSuccessful(items: newItems)
            }
        })
    }
    
    //MARK:View Pending Approval Donation for Requestor
    func ViewPendingApprovalDonations(){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "donationStatus").queryEqual(toValue:Utility.PENDINGAPPROVAL).observe(.value, with: { (snapshot) in
            var newItems = [Donation]()
            if !snapshot.exists() {
                self.PendingApprovalDonationsDelegate?.viewPendingApprovalDonationUnSuccessful(items: newItems)
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    if donationItem.requestorUserID == Utility.userID {
                        newItems.append(donationItem)
                    }
                }
                self.PendingApprovalDonationsDelegate?.viewPendingApprovalDonationSuccessful(items: newItems)
            }
        })
    }
    
    
    //MARK:View Reserve Available Donation for Requestor
    func reserveAvailableDonations(donationID:String,status:String,requestorID:String,requestorSignalIds: [String]){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        let donationItemRef = ref.child(donationID)
        let childUpdates =
            ["donationStatus": status,
            "requestorUserID": requestorID,
            "requestorSignalIds": requestorSignalIds
        ] as [String : Any]
        donationItemRef.updateChildValues(childUpdates){ (error, ref) -> Void in
            if error == nil{
                self.reserveAvailableDonationsDelegate?.reserveAvailableDonationSuccessful(status: status)
                
            }else{
                self.reserveAvailableDonationsDelegate?.reserveAvailableUnSuccessful(error: error!)
            }
            
        }
    }
    
    
    
    //MARK:Helper methods
    //Inovoke firebase User service to get Usertype
    func getUserDetails(){
        let path = String(format: "Users/%@",Utility.userID!)
        let ref = FIRDatabase.database().reference(withPath:path)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() { return }
            let snapDict = snapshot.value as? [String:AnyObject]
            Utility.userType = snapDict?["userType"] as? String
            Utility.restaurantName = snapDict?["restaurantName"]as? String
            Utility.address1 = snapDict?["address1"]as? String
            Utility.address2 = snapDict?["address2"]as? String
            Utility.city = snapDict?["city"]as? String
            Utility.state = snapDict?["state"]as? String
            Utility.zipCode = snapDict?["zipcode"]as? String
            Utility.contact = snapDict?["contact"]as? String
            Utility.charityName = snapDict?["orgName"]as? String
            self.loginDelegate?.loginSuccessful()
        })
    }
    
}



