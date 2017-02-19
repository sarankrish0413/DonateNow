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

class RequestorAcceptedDonationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,viewAcceptedDonationsProtocol,viewDonationDetailsProtocol,viewPendingApprovalDonationsProtocol{
    
    @IBOutlet weak var acceptedDonationsTableView: UITableView!
    var activityIndicator:UIActivityIndicatorView!
    var totalItems = [Donation]()
    var donationID:String!
    let webSerV = Webservice()
    
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //show activity inidcator view
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webSerV.viewAcceptedDonationsDelegate = self
        webSerV.PendingApprovalDonationsDelegate = self
        webSerV.ViewPendingApprovalDonations()
        self.acceptedDonationsTableView.reloadData()
    }
    
    //MARK:Table view DataSource and Delegate Methods
    //Returns number of sections in Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalItems.count
    }
    
    //Set Data for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.acceptedDonationsTableView.dequeueReusableCell(withIdentifier:"AcceptedDonationsTableViewCellIdentifier", for: indexPath) as!RequestorAcceptedDonationsTableViewCell
        let row = indexPath.row
        cell.restaurantNameLabel.text = totalItems[row].restaurantName
        let date = totalItems[row].createdDate
        cell.dateLabel.text = date.components(separatedBy: " ").first
        cell.foodDescLabel.text = totalItems[row].donationTitle
        cell.statusLabel.text = totalItems[row].donationStatus
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        donationID = totalItems[indexPath.row].donationID
        let webSerV: Webservice = Webservice()
        webSerV.viewDonationDetailsDelegate = self
        webSerV.ViewDonationDetails(donationID: donationID)
    
    }
    
    //MARK: view available donations protocol methods
    func viewAcceptedDonationSuccessful(items: [Donation]) {
        activityIndicator.stopAnimating()
        self.totalItems.append(contentsOf: items)
        self.acceptedDonationsTableView.reloadData()
        
    }
    func viewAcceptedDonationUnSuccessful() {

        activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Message", message:"No Donations available", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK: view Pending approval donations protocol methods
    func viewPendingApprovalDonationSuccessful(items: [Donation]) {
        activityIndicator.stopAnimating()
        self.totalItems = items
        webSerV.ViewAcceptedDonations()
    }
    func viewPendingApprovalDonationUnSuccessful(items: [Donation]) {
        activityIndicator.stopAnimating()
        self.totalItems = items
        webSerV.ViewAcceptedDonations()
    }
    
    //MARK viewDonationDetailsProtocol Methods
    func viewDonationDetailsSuccessful(itemsDict:Dictionary<String, Any>){
        let viewDonationViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewDonationDetailsViewController") as? ViewDonationDetailsViewController
        viewDonationViewControllerObj?.donationDetails = itemsDict
        viewDonationViewControllerObj?.donationID = donationID
        Utility.className = Utility.acceptedDonations
        //self.navigationController?.pushViewController(viewDonationViewControllerObj!, animated: true)
        let navController = UINavigationController(rootViewController: viewDonationViewControllerObj!) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated: true, completion: nil)
    }
    
    func viewDonationDetailsUnSuccessful(){
        
        activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Message", message:"Could not fetch the Details. Please try again sometime", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

}
