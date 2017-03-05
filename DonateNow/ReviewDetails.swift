//
//  ReviewDetails.swift
//  DonateNow
//
//  Created by Gayathri Palanisami on 2/22/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Review {
    var restaurantId : String = ""
    var orgId : String = ""
    var rating : String = ""
    var review : String = ""
    var reviewDate: String = ""
    var orgName: String = ""
    var restaurantName: String = ""
    let ref: FIRDatabaseReference?

    init(restaurantId: String, orgId: String, rating: String, review: String, reviewDate: String, orgName: String, restaurantName: String) {
        self.restaurantId = restaurantId
        self.orgId = orgId
        self.rating = rating
        self.review = review
        self.reviewDate = reviewDate
        self.orgName = orgName
        self.restaurantName = restaurantName
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        if let item = snapshotValue["restaurantId"] as? String {
            restaurantId = item
        }
        if let item = snapshotValue["orgId"] as? String {
            orgId = item
        }
        if let item = snapshotValue["rating"] as? String {
            rating = item
        }
        if let item = snapshotValue["review"] as? String {
            review = item
        }
        if let item = snapshotValue["reviewDate"] as? String {
            reviewDate = item
        }
        if let item = snapshotValue["orgName"] as? String {
            orgName = item
        }
        if let item = snapshotValue["restaurantName"] as? String {
            restaurantName = item
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
    return [
        "restaurantId" : restaurantId,
        "orgId" : orgId,
        "rating" : rating,
        "review" : review,
        "reviewDate": reviewDate,
        "orgName": orgName,
        "restaurantName": restaurantName
    ]
    }
}
