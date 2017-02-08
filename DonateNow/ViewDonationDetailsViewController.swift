//
//  ViewDonationDetailsViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/5/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit

class ViewDonationDetailsViewController: UIViewController{
    
    var donationIndex:Int!
    
    //MARK: Outlets
    @IBOutlet weak var actionButton: UIButton!
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
        
        actionButton.backgroundColor = UIColor.lightGray
        actionButton.layer.cornerRadius = 5
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        //Disable user interaction if it is from accepted donation page
        if(Utility.className == Utility.acceptedDonations){
            actionButton.isHidden = true
            foodDescTextView.isUserInteractionEnabled = false
            splInstTextView.isUserInteractionEnabled = false
            zipcodeTextField.isUserInteractionEnabled = false
            stateTextField.isUserInteractionEnabled = false
            cityTextField.isUserInteractionEnabled = false
            address2TextField.isUserInteractionEnabled = false
            address1TextField.isUserInteractionEnabled = false
            contactTextField.isUserInteractionEnabled = false
            qtyTextField.isUserInteractionEnabled = false
            toDateTextField.isUserInteractionEnabled = false
            fromDateTextField.isUserInteractionEnabled = false
            
            //show navigation controller for view Donation details page
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            let logoutButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("Logout")))
            self.navigationItem.rightBarButtonItem = logoutButton
            
            // Status bar black font
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.title = "Welcome Charity!!"
        }
        else if(Utility.className == Utility.myDonations){
            actionButton.isHidden = false
            actionButton.setTitle("Update", for: UIControlState.normal)
            
            //show navigation controller for view Donation details page
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            let logoutButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("Logout")))
            self.navigationItem.rightBarButtonItem = logoutButton
            
            // Status bar black font
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.title = "Welcome Thai Ginger!!"
        }
        
//        //Set value for Donation Details page
//        foodDescTextView.text = Utility.DonationsArray[donationIndex].foodDesc
//        splInstTextView.text = Utility.DonationsArray[donationIndex].splInstructions
//        zipcodeTextField.text = Utility.DonationsArray[donationIndex].zipcode
//        stateTextField.text = Utility.DonationsArray[donationIndex].state
//        cityTextField.text = Utility.DonationsArray[donationIndex].city
//        address2TextField.text = Utility.DonationsArray[donationIndex].address2
//        address1TextField.text = Utility.DonationsArray[donationIndex].address1
//        contactTextField.text = Utility.DonationsArray[donationIndex].contact
//        qtyTextField.text = Utility.DonationsArray[donationIndex].quantity
//        toDateTextField.text = Utility.DonationsArray[donationIndex].pickUpToDate
//        fromDateTextField.text = Utility.DonationsArray[donationIndex].pickUpFromDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction Methods
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
    //set the value for toDate textfield when the user clicks on done
    func toDatePickerValueChanged(sender:UIDatePicker) {
        let datestring = datePickerValuechanged(sender: sender)
        toDateTextField.text = datestring
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
    
    //Set the Date format for Datepicker
    func datePickerValuechanged(sender:UIDatePicker) -> String{
        //date format for DB
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        //Date Format for UI
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone!
        //dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let dateFromString = dateFormatter.string(from: sender.date )
        return dateFromString
    }
    
    

    
    
}
