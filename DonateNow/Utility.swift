//
//  Utility.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/5/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation

class Utility {
    static var DonationsArray = [Donation]()
    static var userType:String?
    static var userID:String?
    static var selectedUserType:String?
    static var userName:String?
    static var restaurantName:String?
    static var address1: String?
    static var address2: String?
    static var city: String?
    static var state: String?
    static var zipCode: String?
    static var contact: String?
    static var charityName: String?
    
    //MARK Constants
    static let DONOR = "DONOR"
    static let REQUESTOR = "REQUESTOR"
    static let NEW = "NEW"
    static let ACCEPTED = "ACCEPTED"
    static let PENDINGAPPROVAL = "PENDING APPROVAL"
    static let REJECTED = "REJECTED"
    
   
    
}
