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

class RequestorViewReviewsController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var restaurants = [User]()
    @IBOutlet var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference(withPath: "Users")
        ref.queryOrdered(byChild: "restaurantName").observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
            }
            else {
                for item in snapshot.children {
                    let user = User(snapshot: item as! FIRDataSnapshot)
                    if (!user.restaurantName.isEmpty) {
                        self.restaurants.append(user)
                    }
                }
                DispatchQueue.main.async {
                    self.picker.reloadAllComponents()
                }
            }
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return restaurants.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return restaurants[row].restaurantName
    }
    
    @IBAction func writeReviewAction(_ sender: UIButton) {
        let ref = FIRDatabase.database().reference(withPath: "Users")
        let writeReviewControllerObj = storyboard?.instantiateViewController(withIdentifier: "RequestorWriteReviewsController") as! RequestorWriteReviewsController
        writeReviewControllerObj.restaurant = restaurants[picker.selectedRow(inComponent: 0)].userID
        navigationController?.pushViewController(writeReviewControllerObj, animated: true)
    }
}
