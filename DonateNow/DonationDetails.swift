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
    var foodDesc:String = ""
    var quantity:String  = ""
    var pickUpFromDate:String = ""
    var pickUpToDate:String = ""
    var contact:String = ""
    var address1:String = ""
    var address2:String = ""
    var city:String = ""
    var state:String = ""
    var zipcode:String = ""
    var splInstructions:String = ""
    var createdUserID:String = ""
    var createdDate:String = ""
    var donationID:String = ""
    var donationStatus:String = ""
    var donationTitle:String = ""
    var restaurantName:String = ""
    var requestorUserID: String = ""
    var signalIds = [String]()
    var requestorSignalIds = [String]()
    var approvalStatus: String = ""
    var rejectedUserIds = [String]()
    let ref:FIRDatabaseReference?
    
    init(foodDesc: String, quantity: String, contact: String, address1: String, address2: String, city: String, state: String, zipcode: String, splInstructions: String, createdUserID: String, createdDate: String, pickUpFromDate: String, pickUpToDate:String, donationID:String, donationStatus: String, donationTitle: String, restaurantName: String,requestorUserID: String,key:String = " ") {
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
        self.createdUserID = createdUserID
        self.donationID = donationID
        self.donationStatus = donationStatus
        self.donationTitle = donationTitle
        self.restaurantName = restaurantName
        self.requestorUserID = requestorUserID
        self.key = key
        self.ref = nil
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        if let item = snapshotValue["foodDesc"] as? String {
            foodDesc = item
        }
        if let item = snapshotValue["quantity"] as? String {
            quantity = item
        }
        if let item = snapshotValue["pickUpFromDate"] as? String {
            pickUpFromDate = item
        }
        if let item = snapshotValue["pickUpToDate"] as? String {
            pickUpToDate = item
        }
        if let item = snapshotValue["contact"] as? String {
            contact = item
        }
        if let item = snapshotValue["address1"] as? String {
            address1 = item
        }
        if let item = snapshotValue["address2"] as? String {
            address2 = item
        }
        if let item = snapshotValue["city"] as? String {
            city = item
        }
        if let item = snapshotValue["state"] as? String {
            state = item
        }
        if let item = snapshotValue["zipcode"] as? String {
            zipcode = item
        }
        if let item = snapshotValue["splInstructions"] as? String {
            splInstructions = item
        }
        if let item = snapshotValue["createdDate"] as? String {
            createdDate = item
        }
        if let item = snapshotValue["createdUserID"] as? String {
            createdUserID = item
        }
        if let item = snapshotValue["donationID"] as? String {
            donationID = item
        }
        if let item = snapshotValue["donationStatus"] as? String {
            donationStatus = item
        }
        if let item = snapshotValue["donationTitle"] as? String {
            donationTitle = item
        }
        if let item = snapshotValue["restaurantName"] as? String {
            restaurantName = item
        }
        if let item = snapshotValue["requestorUserID"] as? String {
            requestorUserID = item
        }
        if let item = snapshotValue["approvalStatus"] as? String {
            approvalStatus = item
        }
        if var signalIds = snapshotValue["signalIds"] as? [String] {
            signalIds.append(contentsOf: signalIds)
        }
        if var requestorSignalIds = snapshotValue["requestorSignalIds"] as? [String] {
            requestorSignalIds.append(contentsOf: requestorSignalIds)
        }
        if let rejectedIds = snapshotValue["rejectedUserIds"] as? [String] {
            rejectedUserIds.append(contentsOf: rejectedIds)
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
            "createdUserID" : createdUserID,
            "donationID" : donationID,
            "donationStatus" : donationStatus,
            "donationTitle":donationTitle,
            "restaurantName":restaurantName,
            "requestorUserID": requestorUserID,
            "signalIds": signalIds,
            "requestorSignalIds": requestorSignalIds,
            "approvalStatus": approvalStatus,
            "rejectedUserIds": rejectedUserIds
        ]
    }
    
}
