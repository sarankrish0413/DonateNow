//
//  DonationDetails.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/5/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import FirebaseDatabase

//Model Class for Donation Details
struct Donation {
    let key:String
    var foodDesc:String
    var quantity:String
    var pickUpFromDate:String
    var pickUpToDate:String
    var contact:String
    var address1:String
    var address2:String
    var city:String
    var state:String
    var zipcode:String
    var splInstructions:String
    var createdUserName:String
    var createdDate:String
    var donationID:String
    var donationStatus:String
    var donationTitle:String
    var restaurantName:String
    var signalIds = [String]()

    let ref:FIRDatabaseReference?
    
    init(foodDesc: String, quantity: String, contact: String, address1: String, address2: String, city: String, state: String, zipcode: String, splInstructions: String, createdUserName: String, createdDate: String, pickUpFromDate: String, pickUpToDate:String, donationID:String, donationStatus: String, donationTitle: String, restaurantName: String,key:String = " ") {
        
        self.foodDesc = foodDesc
        self.quantity = quantity
        self.pickUpFromDate = pickUpFromDate
        self.pickUpToDate = pickUpToDate
        self.contact = contact
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.splInstructions = splInstructions
        self.createdDate = createdDate
        self.createdUserName = createdUserName
        self.donationID = donationID
        self.donationStatus = donationStatus
        self.donationTitle = donationTitle
        self.restaurantName = restaurantName
        self.key = key
        self.ref = nil

    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        foodDesc = snapshotValue["foodDesc"] as! String
        quantity = snapshotValue["quantity"] as! String
        pickUpFromDate = snapshotValue["pickUpFromDate"] as! String
        pickUpToDate = snapshotValue["pickUpToDate"] as! String
        contact = snapshotValue["contact"] as! String
        address1 = snapshotValue["address1"] as! String
        address2 = snapshotValue["address2"] as! String
        city = snapshotValue["city"] as! String
        state = snapshotValue["state"] as! String
        zipcode = snapshotValue["zipcode"] as! String
        splInstructions = snapshotValue["splInstructions"] as! String
        createdDate = snapshotValue["createdDate"] as! String
        createdUserName = snapshotValue["createdUserName"] as! String
        donationID = snapshotValue["donationID"] as! String
        donationStatus = snapshotValue["donationStatus"] as! String
        donationTitle = snapshotValue["donationTitle"] as! String
        restaurantName = snapshotValue["restaurantName"] as! String
        if var signalIds = snapshotValue["signalIds"] as? [String] {
            signalIds.append(contentsOf: signalIds)
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "foodDesc" : foodDesc,
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
            "createdDate" : createdDate,
            "createdUserName" : createdUserName,
            "donationID" : donationID,
            "donationStatus" : donationStatus,
            "donationTitle":donationTitle,
            "restaurantName":restaurantName,
            "signalIds": signalIds
        ]
    }

}
