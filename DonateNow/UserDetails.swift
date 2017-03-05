//
//  UserDetails.swift
//  DonateNow
//
//  Created by Gayathri Palanisami on 2/7/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct User {
    let key: String
    var firstName: String
    var lastName: String
    var email: String
    var userType: String
    var restaurantName: String
    var orgName: String
    var address1: String
    var address2: String
    var city: String
    var state: String
    var zipcode: String
    var contact: String
    var weburl: String
    var orgId: String
    var userID: String
    let ref: FIRDatabaseReference?
    var oneSignalIds = [String]()
    
    init(firstName: String,lastName: String, email: String, userType: String, restaurantName: String, orgName: String, address1: String, address2: String, city: String, state: String, zipcode: String, contact: String, weburl: String, orgId: String, userID: String, key:String = " ") {
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userType = userType
        self.restaurantName = restaurantName
        self.orgName = orgName
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.contact = contact
        self.weburl = weburl
        self.orgId = orgId
        self.userID = userID
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        
        //TODO: Use if let
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        email = snapshotValue["email"] as! String
        userType = snapshotValue["userType"] as! String
        restaurantName = snapshotValue["restaurantName"] as! String
        orgName = snapshotValue["orgName"] as! String
        address1 = snapshotValue["address1"] as! String
        address2 = snapshotValue["address2"] as! String
        city = snapshotValue["city"] as! String
        state = snapshotValue["state"] as! String
        zipcode = snapshotValue["zipcode"] as! String
        contact = snapshotValue["contact"] as! String
        weburl = snapshotValue["weburl"] as! String
        orgId = snapshotValue["orgId"] as! String
        userID = snapshotValue["userID"] as! String
        ref = snapshot.ref
        if let signalIds = snapshotValue["signalIds"] as? [String] {
            oneSignalIds.append(contentsOf: signalIds)
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "firstName" : firstName,
            "lastName" : lastName,
            "email" : email,
            "userType" : userType,
            "restaurantName" : restaurantName,
            "orgName" : orgName,
            "address1" : address1,
            "address2" : address2,
            "city" : city,
            "state" : state,
            "zipcode" : zipcode,
            "contact" : contact,
            "weburl" : weburl,
            "orgId" : orgId,
            "userID" : userID,
            "signalIds" : oneSignalIds

        ]
    }
}
