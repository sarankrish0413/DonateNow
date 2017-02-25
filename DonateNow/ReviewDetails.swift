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
    var restaurantId : String
    var orgId : String
    var rating : String
    var review : String
    let ref: FIRDatabaseReference?

    init(restaurantId: String, orgId: String, rating: String, review: String) {
        self.restaurantId = restaurantId
        self.orgId = orgId
        self.rating = rating
        self.review = review
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        restaurantId = snapshotValue["restaurantId"] as! String
        orgId = snapshotValue["orgId"] as! String
        rating = snapshotValue["rating"] as! String
        review = snapshotValue["review"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
    return [
        "restaurantId" : restaurantId,
        "orgId" : orgId,
        "rating" : rating,
        "review" : review
    ]
    }
}
