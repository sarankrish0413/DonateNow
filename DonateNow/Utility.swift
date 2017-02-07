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
    static let acceptedDonations = "ACCEPTED DONATIONS"
    static let myDonations = "MY DONATIONS"
 
    static var DonationsArray = [Donation]()
}
