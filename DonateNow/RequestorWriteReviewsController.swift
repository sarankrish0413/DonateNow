//
//  RequestorWriteReviewsController.swift
//  DonateNow
//
//  Created by Gayathri Palanisami on 2/21/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import FirebaseDatabase

class RequestorWriteReviewsController : UIViewController {
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var starView: CosmosView!
    var restaurant : String?
    var orgId : String = Utility.userID!
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if let restaurant = restaurant {
            addReviewsToFireBaseDatabase(restaurant: restaurant, orgId: orgId, starView: "\(starView.rating)", reviewTextView: reviewTextView.text)
        }
    }
    
    func addReviewsToFireBaseDatabase(restaurant: String, orgId: String, starView: String, reviewTextView: String) {
        
        let ref = FIRDatabase.database().reference(withPath: "Review")
        var review = Review(restaurantId: restaurant, orgId: orgId, rating: starView, review: reviewTextView)
        let reviewItemRef = ref.child(UUID.init().uuidString)
        reviewItemRef.setValue(review.toAnyObject()){ (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
    }
}
