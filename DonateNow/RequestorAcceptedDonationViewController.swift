//
//  RequestorAcceptedDonationViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/5/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit

class RequestorAcceptedDonationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //MARK: Outlets
    @IBOutlet weak var acceptedDonationsTableView: UITableView!
    
    //MARK:Table view DataSource and Delegate Methods
    //Returns number of sections in Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utility.DonationsArray.count;
    }
    
    //Set Data for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.acceptedDonationsTableView.dequeueReusableCell(withIdentifier:"AcceptedDonationsTableViewCellIdentifier", for: indexPath) as!RequestorAcceptedDonationsTableViewCell
        let row = indexPath.row
        cell.restaurantNameLabel.text = "Restaurant"
        let date = Utility.DonationsArray[row].pickUpFromDate?.components(separatedBy: " ").first
        cell.dateLabel.text = date
        cell.foodDescLabel.text = Utility.DonationsArray[row].foodDesc
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print(row)
        let viewDonationViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewDonationDetailsViewController") as? ViewDonationDetailsViewController
        self.navigationController?.pushViewController(viewDonationViewControllerObj!, animated: true)
        Utility.className = Utility.acceptedDonations
    
    }

    
    
}
