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
import FirebaseAnalytics

class RequestorAcceptedDonationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,viewAcceptedDonationsProtocol,viewDonationDetailsProtocol,viewPendingApprovalDonationsProtocol,viewRejectedDonationsProtocol{
    
    @IBOutlet weak var acceptedDonationsTableView: UITableView!
    var activityIndicator:UIActivityIndicatorView!
    var totalItems = [Donation]()
    var donationID:String!
    let webSerV = Webservice()
    
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase Analytics
        FIRAnalytics.logEvent(withName: "requestor_my_requests", parameters: [
            "userID": Utility.userID! as String as NSObject,
            ])
        
        //show activity inidcator view
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        webSerV.viewAcceptedDonationsDelegate = self
        webSerV.PendingApprovalDonationsDelegate = self
        webSerV.viewRejectedDonationsDelegate = self
        webSerV.ViewPendingApprovalDonations()
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
        let status = totalItems[row].donationStatus
        if status == Utility.NEW{
            cell.statusLabel.textColor = UIColor(colorLiteralRed: 45/255, green: 62/255, blue: 79/255, alpha: 1.0)
        }
        else if status == Utility.PENDINGAPPROVAL {
            cell.statusLabel.textColor = UIColor(colorLiteralRed: 209/255, green: 73/255, blue: 59/255, alpha: 1.0)
        }
        else if status == Utility.REJECTED {
            cell.statusLabel.textColor = UIColor.red
        }
        else {
            cell.statusLabel.textColor = UIColor.green
        }

        cell.restaurantNameLabel.text = totalItems[row].restaurantName
        let date = totalItems[row].createdDate
        cell.dateLabel.text = date.components(separatedBy: " ").first
        cell.foodDescLabel.text = totalItems[row].donationTitle
        cell.statusLabel.text = totalItems[row].approvalStatus
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        donationID = totalItems[indexPath.row].donationID
        let webSerV: Webservice = Webservice()
        webSerV.viewDonationDetailsDelegate = self
        webSerV.ViewDonationDetails(donationID: donationID)
    
    }
    
    //MARK: view available donations protocol methods
    func viewRejectedDonationSuccessful(items: [Donation]) {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.totalItems.append(contentsOf: items)
        DispatchQueue.main.async {
            self.acceptedDonationsTableView.reloadData()
        }
    }
    
    //MARK: view available donations protocol methods
    func viewAcceptedDonationSuccessful(items: [Donation]) {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.totalItems.append(contentsOf: items)
        webSerV.ViewRejectedDonations()
    }
    
 
    
    //MARK: view Pending approval donations protocol methods
    func viewPendingApprovalDonationSuccessful(items: [Donation]) {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.totalItems = items
        webSerV.ViewAcceptedDonations()
    }
    
    
    //MARK viewDonationDetailsProtocol Methods
    func viewDonationDetailsSuccessful(itemsDict:Dictionary<String, Any>){
        let viewDonationViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewDonationDetailsViewController") as? ViewDonationDetailsViewController
        viewDonationViewControllerObj?.donationDetails = itemsDict
        viewDonationViewControllerObj?.donationID = donationID
        let navController = UINavigationController(rootViewController: viewDonationViewControllerObj!) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated: true, completion: nil)
    }
    
    func viewDonationDetailsUnSuccessful(){
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        let alertController = UIAlertController(title: "Message", message:"Could not fetch the Details. Please try again sometime", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

}
