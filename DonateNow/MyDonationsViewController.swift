//
//  MyDonationsViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/4/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit

class MyDonationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //MARK: Outlets
    @IBOutlet weak var myDonationsTableView: UITableView!
    
    
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
        
        let cell = self.myDonationsTableView.dequeueReusableCell(withIdentifier:"DonationTableViewCellIdentifier", for: indexPath) as!MyDonationTableViewCell
        let row = indexPath.row
        cell.statusLabel.text = "New"
        let date = Utility.DonationsArray[row].pickUpFromDate?.components(separatedBy: " ").first
        cell.dateLabel.text = date
        cell.descriptionLabel.text = Utility.DonationsArray[row].foodDesc
        return cell
    }
    
    //show the Donation details page  when user taps on table row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print(row)
        let viewDonationViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewDonationDetailsViewController") as? ViewDonationDetailsViewController
        self.navigationController?.pushViewController(viewDonationViewControllerObj!, animated: true)
        viewDonationViewControllerObj?.donationIndex = row
        Utility.className = Utility.myDonations
    }
    
}
