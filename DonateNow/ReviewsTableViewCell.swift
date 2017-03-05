//
//  ReviewsTableViewCell.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 3/4/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class ReviewsTableViewCell : UITableViewCell {
    @IBOutlet weak var reviewCommentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingsView: CosmosView!
    @IBOutlet weak var userNameLabel: UILabel!
}
