//
//  RequestorViewReviewsController.swift
//  DonateNow
//
//  Created by Gayathri Palanisami on 2/21/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class RequestorViewReviewsController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, viewRestaurantProtocol,viewRequestorReviewProtocol {
    
    @IBOutlet weak var writeReviewsButton: UIButton!
    var restaurants = [User]()
    var reviews = [Review]()
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
                
        //Draw border for write review Button
        writeReviewsButton.layer.cornerRadius = 19
        writeReviewsButton.layer.borderWidth = 1
        writeReviewsButton.layer.borderColor = UIColor.clear.cgColor
        
        //get Restuarant Name
        let webSerV: Webservice = Webservice()
        webSerV.viewRestaurantsDelegate = self
        webSerV.getRestaurantName()
    
    }
    
    //MARK: UIPickerview Delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return restaurants.count
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // get Restuarant reviews
        let webSerV: Webservice = Webservice()
        webSerV.viewRequestorReviewDelegate = self
        webSerV.getRestaurantReviews(restaurantID: restaurants[row].userID)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = restaurants[row].restaurantName
        pickerLabel.font = UIFont(name: "Futura", size: 16) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    @IBAction func writeReviewAction(_ sender: UIButton) {
        let writeReviewControllerObj = storyboard?.instantiateViewController(withIdentifier: "RequestorWriteReviewsController") as! RequestorWriteReviewsController
        writeReviewControllerObj.restaurant = restaurants[picker.selectedRow(inComponent: 0)].userID
        writeReviewControllerObj.orgName = Utility.charityName
        writeReviewControllerObj.restaurantName = restaurants[picker.selectedRow(inComponent: 0)].restaurantName
        navigationController?.pushViewController(writeReviewControllerObj, animated: true)
    }
    
    //MARK:viewRestaurantProtocol Delegate Methods
    func viewRestaurantSuccessful(restaurantName:[User]) {
        restaurants = restaurantName
        DispatchQueue.main.async {
            self.picker.reloadAllComponents()
        }
        
    }
    
    //MARK: view Requestor review protocol
    func viewRequestorReviewSuccessful(items:[Review]) {
        reviews = items
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension RequestorViewReviewsController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:Table view DataSource and Delegate Methods
    //Returns number of sections in Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
