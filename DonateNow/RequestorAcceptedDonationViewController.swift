//
//  RequestorAcceptedDonationViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/5/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class RequestorAcceptedDonationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var items: [Donation] = []
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveDonations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Outlets
    @IBOutlet weak var acceptedDonationsTableView: UITableView!
    
    //MARK:Table view DataSource and Delegate Methods
    //Returns number of sections in Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //Set Data for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.acceptedDonationsTableView.dequeueReusableCell(withIdentifier:"AcceptedDonationsTableViewCellIdentifier", for: indexPath) as!RequestorAcceptedDonationsTableViewCell
        let row = indexPath.row
        cell.restaurantNameLabel.text = "Restaurant1"
        let date = items[row].createdDate
        cell.dateLabel.text = date.components(separatedBy: " ").first
        cell.foodDescLabel.text = items[row].foodDesc
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print(row)
        let viewDonationViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewDonationDetailsViewController") as? ViewDonationDetailsViewController
        self.navigationController?.pushViewController(viewDonationViewControllerObj!, animated: true)
        Utility.className = Utility.acceptedDonations
    
    }
    
    func retrieveDonations(){
        
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        //Retrieve Donation Details
        ref.queryOrdered(byChild: "donationStatus").observe(.value, with: { snapshot in
            var newItems: [Donation] = []
            for item in snapshot.children {
                let donationItem = Donation(snapshot: item as! FIRDataSnapshot)
                newItems.append(donationItem)
            }
            self.items = newItems
            self.acceptedDonationsTableView.reloadData()
        })
    }

    
    
}
