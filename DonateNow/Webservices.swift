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

//New Donations service Protocol
protocol newDonationProtocol{
    func newDonationSuccessful()
    func newDonationUnSuccessful(error:Error)
}

//View List of donations based on user logged in
protocol viewNewDonationProtocol {
    func viewNewDonationsSuccessful(items:[Donation])
    func viewNewDonationUnSuccessful()
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
    func viewAvailableDonationUnSuccessful()
}

//Reserve for Available Donations
protocol reserveAvailableDonationsProtocol {
    func reserveAvailableDonationSuccessful()
    func reserveAvailableUnSuccessful(error:Error)
}
//View accepted donations requestor
protocol viewAcceptedDonationsProtocol{
    func viewAcceptedDonationSuccessful(items:[Donation])
    func viewAcceptedDonationUnSuccessful()
}


class Webservice {
    
    var loginDelegate:loginWebserviceProtocol?
    var signupDelegate:signupWebserviceProtocol?
    var newDonationDelegate:newDonationProtocol?
    var viewNewDonationDelegate:viewNewDonationProtocol?
    var viewDonationDetailsDelegate:viewDonationDetailsProtocol?
    var updateDonationsDelegate:updateDonationDetailsProtocol?
    var viewAvailableDonationsDelegate:viewAvailableDonationsProtocol?
    var reserveAvailableDonationsDelegate:reserveAvailableDonationsProtocol?
    var viewAcceptedDonationsDelegate:viewAcceptedDonationsProtocol?
    
    //MARK:Login related Service
    //Invoke firebase login service
    func loginService(username:String,password:String) {
        
        FIRAuth.auth()?.signIn(withEmail: username, password: password) { (user, error) in
            if error == nil {
                print("uudi:",user!.uid)
                Utility.userID = user!.uid
                Utility.userName = user!.email
                self .getUserType()
            }
            else {
                self.loginDelegate?.loginUnSuccessful(error: error!)
            }
            
        }
    }
    
    //MARK:Signup related Service
    //Invoke firebase signup service For Donor
    func signupServiceForDonor(username:String, email:String, userType:String, restaurantName: String, orgName: String, address1: String, address2: String, city: String, state: String, zipcode: String, contact:String, websiteUrl: String, orgId: String, userID: String){
        let ref = FIRDatabase.database().reference(withPath: "Users")
        let user = User(username: username, email: email, userType: userType, restaurantName: restaurantName, orgName: orgName, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode,contact: contact, weburl: websiteUrl, orgId: orgId, userID: userID)
        let userRef = ref.child(userID)
        userRef.setValue(user.toAnyObject())
    }
    
    //Invoke firebase signup service For Requestor
    func signupServiceForRequestor(username:String, email:String, userType:String, restaurantName: String, orgName: String, address1: String, address2: String, city: String, state: String, zipcode: String, contact:String, websiteUrl: String, orgId: String, userID: String){
        let ref = FIRDatabase.database().reference(withPath: "Users")
        let user = User(username: username, email: email, userType: userType, restaurantName: restaurantName, orgName: orgName, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode,contact: contact, weburl: websiteUrl, orgId: orgId, userID: userID)
        let userRef = ref.child(userID)
        userRef.setValue(user.toAnyObject())
    }
    
    //Invoke firebase create user service
    func createNewUser(username:String,password:String){
        FIRAuth.auth()?.createUser(withEmail: username, password: password) { (user, error) in
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
    func addDonationDetailsToFireBaseDatabase(foodDesc:String, quantity:String, contact:String, address1:String, address2: String, city:String, state: String, zipcode:String, splInstructions:String, createdUserName:String, createdDate:String, pickUpFromDate:String, pickUpToDate:String, donationID:String, donationStatus:String,donationTitle:String,restaurantName:String){
        
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        let donation = Donation(foodDesc: foodDesc,quantity: quantity,contact: contact,address1: address1,address2: address2,city: city,state: state,zipcode: zipcode,splInstructions: splInstructions,createdUserName: createdUserName,createdDate: createdDate,pickUpFromDate: pickUpFromDate ,pickUpToDate: pickUpToDate,donationID: donationID,donationStatus: donationStatus,donationTitle: donationTitle,restaurantName:restaurantName)
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
        var newItems: [Donation] = []
          ref.queryOrdered(byChild: "createdUserName").queryEqual(toValue: Utility.userID).observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                self.viewNewDonationDelegate?.viewNewDonationUnSuccessful()
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
        var newItems: [Donation] = []
        ref.queryOrdered(byChild: "donationStatus").queryEqual(toValue: Utility.NEW).observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                self.viewAvailableDonationsDelegate?.viewAvailableDonationUnSuccessful()
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
        var newItems: [Donation] = []
        ref.queryOrdered(byChild: "donationStatus").queryEqual(toValue: Utility.ACCEPTED).observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                self.viewAcceptedDonationsDelegate?.viewAcceptedDonationUnSuccessful()
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    newItems.append(donationItem)
                }
                self.viewAcceptedDonationsDelegate?.viewAcceptedDonationSuccessful(items: newItems)
            }
        })
    }
    
    
    //MARK:View Reserve Available Donation for Requestor
    func reserveAvailableDonations(donationID:String,status:String){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        let donationItemRef = ref.child(donationID)
        donationItemRef.updateChildValues(
            ["donationStatus" : status]
        ){ (error, ref) -> Void in
            if error == nil{
                self.reserveAvailableDonationsDelegate?.reserveAvailableDonationSuccessful()
                
            }else{
                self.reserveAvailableDonationsDelegate?.reserveAvailableUnSuccessful(error: error!)
            }
            
        }
    }
    

    
    //MARK:Helper methods
    //Inovoke firebase User service to get Usertype
    func getUserType(){
        let path = String(format: "Users/%@",Utility.userID!)
        let ref = FIRDatabase.database().reference(withPath:path)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() { return }
            let snapDict = snapshot.value as? [String:AnyObject]
            Utility.userType = snapDict?["userType"] as? String
            Utility.restaurantName = snapDict?["restaurantName"]as? String
            self.loginDelegate?.loginSuccessful()
        })
    }
    
    
    
    
}



