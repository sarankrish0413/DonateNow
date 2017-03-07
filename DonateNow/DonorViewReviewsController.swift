//
//  DonorViewReviewsController.swift
//  DonateNow
//
//  Created by Gayathri Palanisami on 2/21/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit

class DonorViewReviewsController : UIViewController, viewRequestorReviewProtocol,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var viewMyReviewsTableView: UITableView!
    var reviews = [Review]()
    var restaurants = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMyReviewsTableView.rowHeight = UITableViewAutomaticDimension
        viewMyReviewsTableView.estimatedRowHeight = 100.0
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // get Restuarant reviews
        super.viewWillAppear(true)
        let webSerV: Webservice = Webservice()
        webSerV.viewRequestorReviewDelegate = self
        webSerV.getRestaurantReviews(restaurantID: Utility.userID!)
    }
    //MARK: view Requestor review protocol
    func viewRequestorReviewSuccessful(items:[Review]) {
        reviews = items
        DispatchQueue.main.async {
            self.viewMyReviewsTableView.reloadData()
        }
    }
    
    //MARK:Table view DataSource and Delegate Methods
    //Returns number of sections in Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsTableViewCell
        let row = indexPath.row
        cell.userNameLabel.text = reviews[row].orgName
        let date = reviews[row].reviewDate
        cell.dateLabel.text = date.components(separatedBy: " ").first
        cell.reviewCommentsLabel.text = reviews[row].review
        cell.ratingsView.rating = Double(reviews[row].rating)!
        return cell
    }

}
