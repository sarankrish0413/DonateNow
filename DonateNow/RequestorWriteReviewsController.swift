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

class RequestorWriteReviewsController : UIViewController,addReviewsProtocol,UITextViewDelegate {
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var submitButton: UIButton!

    var restaurant : String?
    var orgId : String = Utility.userID!
    var orgName: String?
    var restaurantName: String?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.delegate = self
        
        //Draw border for submit Button
        submitButton.layer.cornerRadius = 19
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.clear.cgColor
        
        //Draw border for reviews textview
        reviewTextView.layer.borderWidth = 1.0
        reviewTextView.layer.cornerRadius = 5.0
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        let webSerV: Webservice = Webservice()
        webSerV.addReviewsDelegate = self
        webSerV.addReviewsToFireBaseDatabase(restaurant: restaurant!, orgId: orgId, starView: "\(starView.rating)", reviewTextView: reviewTextView.text, reviewDate: getCurrentDateAndTime(), orgName: orgName!, restaurantName: restaurantName!)
    }
    
   
    
    func getCurrentDateAndTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone!
        let dateFromString = dateFormatter.string(from:NSDate() as Date)
        return dateFromString
    }
    
    //MARK: view reviews protocol methods
    func addReviewSuccessful() {
        _ = self.navigationController?.popViewController(animated: true)

    }
    func addReviewUnSuccessful(error:Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:UITextView Delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == reviewTextView {
            self.view.animateViewMoving(up: true, moveValue: 200)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == reviewTextView {
            self.view.animateViewMoving(up: false, moveValue: 200)
        }
    }
    
    //MARK:Text view Delegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
