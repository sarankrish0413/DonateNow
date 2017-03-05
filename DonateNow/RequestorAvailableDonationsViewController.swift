//
//  RequestorAvailableDonationsViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/15/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

class RequestorAvailableDonationsViewController : UIViewController,UITableViewDelegate,UITableViewDataSource,viewAvailableDonationsProtocol,viewDonationDetailsProtocol {
    var activityIndicator:UIActivityIndicatorView!
    var items: [Donation] = []
    var donationID:String!
    let webSerV: Webservice = Webservice()

    
    @IBOutlet weak var availbleDonationsTableView: UITableView!
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase Analytics
        FIRAnalytics.logEvent(withName: "requestor_available_Donations", parameters: [
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
        webSerV.viewAvailableDonationsDelegate = self
        webSerV.ViewAvailableDonations()
        DispatchQueue.main.async {
            self.availbleDonationsTableView.reloadData()
        }
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
        let cell = self.availbleDonationsTableView.dequeueReusableCell(withIdentifier:"AcceptedDonationsTableViewCellIdentifier", for: indexPath) as!RequestorAcceptedDonationsTableViewCell
        let row = indexPath.row
        let status = items[row].donationStatus
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

        cell.restaurantNameLabel.text = items[row].restaurantName
        let date = items[row].createdDate
        cell.dateLabel.text = date.components(separatedBy: " ").first
        cell.foodDescLabel.text = items[row].donationTitle
        cell.statusLabel.text = items[row].donationStatus
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        donationID = items[row].donationID
        let webSerV: Webservice = Webservice()
        webSerV.viewDonationDetailsDelegate = self
        webSerV.ViewDonationDetails(donationID: donationID)
        
    }
    
    //MARK: view available donations protocol methods
    func viewAvailableDonationSuccessful(items:[Donation]){
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.items = items
        DispatchQueue.main.async {
            self.availbleDonationsTableView.reloadData()
        }
        
    }
    func viewAvailableDonationUnSuccessful(items:[Donation]){
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.items = items
        DispatchQueue.main.async {
            self.availbleDonationsTableView.reloadData()
        }
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

