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

//forgotPassword service Protocol
protocol forgotPasswordProtocol {
    func forgotPasswordSuccessful()
    func forgotPasswordUnSuccessful(error:Error)
}


//New Donations service Protocol
protocol newDonationProtocol{
    func newDonationSuccessful()
    func newDonationUnSuccessful(error:Error)
}

//View List of donations based on user logged in
protocol viewMyDonationProtocol {
    func viewMyDonationsSuccessful(items:[Donation])
    func viewMyDonationUnSuccessful(items:[Donation])
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
protocol updateDonationStatusProtocol {
    func updateDonationStatusSuccessful(status:String)
    func updateDonationStatusUnSuccessful(error:Error)
}
//View accepted donations requestor
protocol viewAcceptedDonationsProtocol{
    func viewAcceptedDonationSuccessful(items:[Donation])
}

//View Pending Approval donations requestor
protocol viewPendingApprovalDonationsProtocol{
    func viewPendingApprovalDonationSuccessful(items:[Donation])
}

//view Rejected donations requestor
protocol viewRejectedDonationsProtocol{
    func viewRejectedDonationSuccessful(items:[Donation])
}

//view restaurant name
protocol viewRestaurantProtocol {
    func viewRestaurantSuccessful(restaurantName:[User])
}

//view Review Details Requestor 
protocol viewRequestorReviewProtocol {
    func viewRequestorReviewSuccessful(items:[Review])
}

//Add Reviews to firebase
protocol addReviewsProtocol {
    func addReviewSuccessful()
    func addReviewUnSuccessful(error:Error)
}



class Webservice {
    //TODO: Change delegates to closures
    var loginDelegate:loginWebserviceProtocol?
    var signupDelegate:signupWebserviceProtocol?
    var logoutDelegate:logoutServiceProtocol?
    var newDonationDelegate:newDonationProtocol?
    var viewMyDonationDelegate:viewMyDonationProtocol?
    var viewDonationDetailsDelegate:viewDonationDetailsProtocol?
    var updateDonationsDelegate:updateDonationDetailsProtocol?
    var viewAvailableDonationsDelegate:viewAvailableDonationsProtocol?
    var updateDonationStatusDelegate:updateDonationStatusProtocol?
    var viewAcceptedDonationsDelegate:viewAcceptedDonationsProtocol?
    var PendingApprovalDonationsDelegate:viewPendingApprovalDonationsProtocol?
    var viewRejectedDonationsDelegate:viewRejectedDonationsProtocol?
    var forgotPasswordDelegate: forgotPasswordProtocol?
    var viewRestaurantsDelegate: viewRestaurantProtocol?
    var viewRequestorReviewDelegate: viewRequestorReviewProtocol?
    var addReviewsDelegate: addReviewsProtocol?
    
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
    func signupServiceForDonor(firstName:String,lastName:String, email:String, userType:String, restaurantName: String, orgName: String, address1: String, address2: String, city: String, state: String, zipcode: String, contact:String, websiteUrl: String, orgId: String, userID: String){
        let ref = FIRDatabase.database().reference(withPath: "Users")
        var user = User(firstName: firstName , lastName: lastName, email: email, userType: userType, restaurantName: restaurantName, orgName: orgName, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode,contact: contact, weburl: websiteUrl, orgId: orgId, userID: userID)
        if let signalId = oneSignalUserData.userId {
            user.oneSignalIds.append(signalId)
        }
        let userRef = ref.child(userID)
        userRef.setValue(user.toAnyObject())
    }
    
    //Invoke firebase signup service For Requestor
    func signupServiceForRequestor(firstName:String,lastName:String, email:String, userType:String, restaurantName: String, orgName: String, address1: String, address2: String, city: String, state: String, zipcode: String, contact:String, websiteUrl: String, orgId: String, userID: String){
        let ref = FIRDatabase.database().reference(withPath: "Users")
        var user = User(firstName: firstName , lastName: lastName, email: email, userType: userType, restaurantName: restaurantName, orgName: orgName, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode,contact: contact, weburl: websiteUrl, orgId: orgId, userID: userID)
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
    
    //Invoke forgot password service
    func forgotPassword(emailID: String){
        FIRAuth.auth()?.sendPasswordReset(withEmail: emailID) { error in
            if error == nil {
                self.forgotPasswordDelegate?.forgotPasswordSuccessful()
            }
            else {
                self.forgotPasswordDelegate?.forgotPasswordUnSuccessful(error: error!)
            }
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
        donation.approvalStatus = Utility.NEW
        donation.requestorSignalIds = [String]()
        donation.rejectedUserIds = [String]()
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
    func ViewMyDonationDetails(){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "createdUserID").queryEqual(toValue: Utility.userID).observe(.value, with: { (snapshot) in
            var newItems = [Donation]()
            if !snapshot.exists() {
                self.viewMyDonationDelegate?.viewMyDonationUnSuccessful(items: newItems)
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    newItems.append(donationItem)
                }
                self.viewMyDonationDelegate?.viewMyDonationsSuccessful(items: newItems)
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
                    debugPrint( donationItem.donationID)
                    if donationItem.rejectedUserIds.contains(Utility.userID!)  {
                    }
                    else{
                        newItems.append(donationItem)
                    }
                }
                self.viewAvailableDonationsDelegate?.viewAvailableDonationSuccessful(items: newItems)
            }
        })
    }
    
    //MARK:View Accepted Donation for Requestor
    func ViewAcceptedDonations(){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "approvalStatus").queryEqual(toValue:Utility.ACCEPTED).observe(.value, with: { (snapshot) in
            var newItems = [Donation]()
            if !snapshot.exists() {
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    if donationItem.requestorUserID == Utility.userID {
                        newItems.append(donationItem)
                    }
                }
            }
            self.viewAcceptedDonationsDelegate?.viewAcceptedDonationSuccessful(items: newItems)
        })

    }
    
    //MARK:View Pending Approval Donation for Requestor
    func ViewPendingApprovalDonations(){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "approvalStatus").queryEqual(toValue:Utility.PENDINGAPPROVAL).observe(.value, with: { (snapshot) in
            var newItems = [Donation]()
            if !snapshot.exists() {
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    if donationItem.requestorUserID == Utility.userID {
                        newItems.append(donationItem)
                    }
                }
            }
            self.PendingApprovalDonationsDelegate?.viewPendingApprovalDonationSuccessful(items: newItems)
        })
    }
    
    //MARK:View Rejected Donation for Requestor
    func ViewRejectedDonations(){
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "approvalStatus").queryEqual(toValue:Utility.REJECTED).observe(.value, with: { (snapshot) in
            var newItems = [Donation]()
            if !snapshot.exists() {
            }
            else {
                for item in snapshot.children {
                    let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                    if donationItem.rejectedUserIds.contains(Utility.userID!) {
                        newItems.append(donationItem)
                    }
                }
            }
            self.viewRejectedDonationsDelegate?.viewRejectedDonationSuccessful(items: newItems)
        })
    }
    
    
    //MARK:View Reserve Available Donation for Requestor
    func updateDonationStatus(donationID:String,status:String,requestorID:String,requestorSignalIds: [String],rejectedUserIds:[String]){
        
        if status != Utility.REJECTED {
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        let donationItemRef = ref.child(donationID)
        let childUpdates =
            ["approvalStatus": status,
            "requestorUserID": requestorID,
            "requestorSignalIds": requestorSignalIds,
            "donationStatus": status
        ] as [String : Any]
        donationItemRef.updateChildValues(childUpdates){ (error, ref) -> Void in
            if error == nil{
                self.updateDonationStatusDelegate?.updateDonationStatusSuccessful(status: status)
                
            }else{
                self.updateDonationStatusDelegate?.updateDonationStatusUnSuccessful(error: error!)
            }
            
        }
        }
        else {
            let ref = FIRDatabase.database().reference(withPath: "Donations")
            let donationItemRef = ref.child(donationID)
            let childUpdates =
                ["approvalStatus": status,
                 "requestorUserID": requestorID,
                 "requestorSignalIds": requestorSignalIds,
                 "rejectedUserIds": rejectedUserIds,
                 "donationStatus": Utility.NEW,
                    ] as [String : Any]
            donationItemRef.updateChildValues(childUpdates){ (error, ref) -> Void in
                if error == nil{
                    self.updateDonationStatusDelegate?.updateDonationStatusSuccessful(status: status)
                    
                }else{
                    self.updateDonationStatusDelegate?.updateDonationStatusUnSuccessful(error: error!)
                }
                
            }
            
        }
    }
    
    //MARK:view Restaurant name
    func getRestaurantName(){
        let ref = FIRDatabase.database().reference(withPath: "Users")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "userType").queryEqual(toValue:Utility.DONOR).observe(.value, with: { (snapshot) in
            var newItems = [User]()
            if !snapshot.exists() {
            }
            else {
                for item in snapshot.children {
                    let restName = User(snapshot: item as! FIRDataSnapshot)
                    if (!restName.restaurantName.isEmpty) {
                        newItems.append(restName)
                    }
            }
            }
            self.viewRestaurantsDelegate?.viewRestaurantSuccessful(restaurantName: newItems)
        })
    }
    
    //MARK: get Restaurant reviews
    func getRestaurantReviews(restaurantID: String){
        let ref = FIRDatabase.database().reference(withPath: "Reviews")
        //Retrieve restaurant reviews
        ref.queryOrdered(byChild: "restaurantId").queryEqual(toValue:restaurantID).observe(.value, with: { (snapshot) in
            var newItems = [Review]()
            if !snapshot.exists() {
            }
            else {
                for item in snapshot.children {
                    let restName = Review(snapshot: item as! FIRDataSnapshot)
                        newItems.append(restName)
                }
            }
            self.viewRequestorReviewDelegate?.viewRequestorReviewSuccessful(items: newItems)
        })
    }
    
    //MARK: Add reviews to firebase database
    func addReviewsToFireBaseDatabase(restaurant: String, orgId: String, starView: String, reviewTextView: String, reviewDate: String, orgName: String, restaurantName: String) {
        let ref = FIRDatabase.database().reference(withPath: "Reviews")
        let review = Review(restaurantId: restaurant, orgId: orgId, rating: starView, review: reviewTextView, reviewDate: reviewDate, orgName: orgName, restaurantName: restaurantName)
        let reviewItemRef = ref.child(UUID.init().uuidString)
        reviewItemRef.setValue(review.toAnyObject()){ (error, ref) -> Void in
            if error == nil {
                self.addReviewsDelegate?.addReviewSuccessful()
            }
            else {
                self.addReviewsDelegate?.addReviewUnSuccessful(error: error!)
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



