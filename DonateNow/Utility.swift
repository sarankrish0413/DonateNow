//
//  Utility.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/5/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation

class Utility {
    static let sharedInstance = Utility()
    static var className:String?
    static var DonationsArray = [Donation]()
    static var userType:String?
    static var userID:String?
    static var selectedUserType:String?
    static var userName:String?
    static var restaurantName:String?

    

    //MARK Constants
    static let acceptedDonations = "ACCEPTED DONATIONS"
    static let myDonations = "MY DONATIONS"
    static let availableDonations = "AVAILABLE DONATIONS"
    static let DONOR = "DONOR"
    static let REQUESTOR = "REQUESTOR"
    static let NEW = "New"
    static let ACCEPTED = "Accepted"
    static let PENDINGAPPROVAL = "Pending Approval"
}
