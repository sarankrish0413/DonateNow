//
//  NewDonationViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/4/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class NewDonationViewController: UIViewController{
    
    //MARK: Outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var foodDescTextView: UITextView!
    @IBOutlet weak var splInstTextView: UITextView!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Draw border for Food description textview
        foodDescTextView.layer.borderWidth = 1.0;
        foodDescTextView.layer.cornerRadius = 5.0;
        foodDescTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        //Draw border for Special instruction textview
        splInstTextView.layer.borderWidth = 1.0;
        splInstTextView.layer.cornerRadius = 5.0;
        splInstTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        addButton.backgroundColor = UIColor.lightGray
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Outlets Action
    //Add Button, capture all the details from form and add it to Donations array
    @IBAction func addButtonAction(_ sender: UIButton) {
        
        
        let uuid = UUID().uuidString
        print(uuid)
       
        addDonationDetailsToFireBaseDatabase(foodDesc: foodDescTextView.text, quantity: qtyTextField.text!, contact: contactTextField.text!, address1: address1TextField.text!, address2: address2TextField.text!, city: cityTextField.text!, state: stateTextField.text!, zipcode: zipcodeTextField.text!, splInstructions: splInstTextView.text!, createdUserName: "testuser", createdDate: getCurrentDateAndTime(), pickUpFromDate: fromDateTextField.text!, pickUpToDate: toDateTextField.text!, donationID: uuid , donationStatus: "New")
        
        //Donor
        let donorViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DonorViewController") as? DonorViewController
        self.navigationController?.pushViewController(donorViewControllerObj!, animated: true)
        
        
        
    }
    
    //Show Date and time picker for fromDate text field
    @IBAction func fromDateTextFieldAction(_ sender: UITextField) {
        //Create the view
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:0, height:0))
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        inputView.addSubview(datePickerView) // add date picker to UIView
        datePickerView.addTarget(self, action: #selector(fromDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        let doneButton = UIButton(frame: CGRect(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        sender.inputView = inputView
        doneButton.addTarget(self, action: #selector(fromDoneButtonAction), for: UIControlEvents.touchUpInside)
        
        fromDatePickerValueChanged(sender: datePickerView)
        
    }
    
    //Show Date and time picker for toDate text field
    @IBAction func toDateTextFieldAction(_ sender: UITextField) {
        //Create the view
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:0, height:0))
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        inputView.addSubview(datePickerView) // add date picker to UIView
        datePickerView.addTarget(self, action: #selector(toDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        let doneButton = UIButton(frame: CGRect(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        sender.inputView = inputView
        doneButton.addTarget(self, action: #selector(toDoneButtonAction), for: UIControlEvents.touchUpInside)
        toDatePickerValueChanged(sender: datePickerView)
        
    }
    
    
    
    
    //MARK: Custom Methods
    //set the value for fromDate textfield when the user clicks on done
    func fromDatePickerValueChanged(sender:UIDatePicker) {
        let datestring = datePickerValuechanged(sender: sender)
        fromDateTextField.text = datestring
        
        
    }
    //Dismiss date picker view
    func fromDoneButtonAction(sender:UIButton)
    {
        fromDateTextField.resignFirstResponder()
    }
    
    //Dismiss date picker view
    func toDoneButtonAction(sender:UIButton)
    {
        toDateTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    //set the value for toDate textfield when the user clicks on done
    func toDatePickerValueChanged(sender:UIDatePicker) {
        let datestring = datePickerValuechanged(sender: sender)
        toDateTextField.text = datestring
    }
    
    //Set the Date format for Datepicker
    func datePickerValuechanged(sender:UIDatePicker) -> String{
        //date format for DB
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        //Date Format for UI
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd hh:mm"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone!
        //dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let dateFromString = dateFormatter.string(from: sender.date )
        return dateFromString
    }
    
    
    func getCurrentDateAndTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone!
        let dateFromString = dateFormatter.string(from:NSDate() as Date)
        return dateFromString
    }
    
    //Add Data to Firebase Database
    func addDonationDetailsToFireBaseDatabase(foodDesc:String, quantity:String, contact:String, address1:String, address2: String, city:String, state: String, zipcode:String, splInstructions:String, createdUserName:String, createdDate:String, pickUpFromDate:String, pickUpToDate:String, donationID:String, donationStatus:String){
        
        let ref = FIRDatabase.database().reference(withPath: "Donations")
        let donation = Donation(foodDesc: foodDesc,quantity: quantity,contact: contact,address1: address1,address2: address2,city: city,state: state,zipcode: zipcode,splInstructions: splInstructions,createdUserName: createdUserName,createdDate: createdDate,pickUpFromDate: pickUpFromDate ,pickUpToDate: pickUpToDate,donationID: donationID,donationStatus: donationStatus)
        let donationItemRef = ref.child(donationID.lowercased())
        donationItemRef.setValue(donation.toAnyObject())
        
        
    }
    
    
    
}
