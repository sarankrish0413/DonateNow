//
//  ViewDonationDetailsViewController.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 2/5/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import Foundation
import UIKit
import OneSignal

class ViewDonationDetailsViewController: UIViewController,updateDonationDetailsProtocol,reserveAvailableDonationsProtocol{
    

    
    var donationDetails:Dictionary<String, Any>!
    var donationID:String!
    var donationDict:Dictionary<String, Any>!

    
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
    
    @IBOutlet weak var donationTitleTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    
 
    @IBOutlet weak var cancelButton: UIButton!
   
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
        
        cancelButton.backgroundColor = UIColor.lightGray
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        
        donationDict = donationDetails?[donationID] as! Dictionary<String,Any>!

        
        
        //Disable user interaction if it is from accepted donation page
        if(Utility.className == Utility.acceptedDonations){
            actionButton.isHidden = true
            
            setUserInteractionForButtons(value: false)
            
            //show navigation controller for view Donation details page
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(false, animated:true)
       
            // Status bar black font
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.title = "Welcome Charity!!"
        }
        else if(Utility.className == Utility.myDonations && (donationDict?["donationStatus"]as?String == Utility.NEW) ){
            actionButton.isHidden = false
            actionButton.setTitle("Update", for: UIControlState.normal)
            
            //show navigation controller for view Donation details page
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            // Status bar black font
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.title = "Welcome Thai Ginger!!"
            
            setUserInteractionForButtons(value: true)
        }
            
        else if(Utility.className == Utility.myDonations && (donationDict?["donationStatus"]as?String == Utility.PENDINGAPPROVAL)){
            actionButton.isHidden = false
            actionButton.setTitle("Approve", for: UIControlState.normal)
            cancelButton.setTitle("Reject", for: UIControlState.normal)
            
            //show navigation controller for view Donation details page
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            // Status bar black font
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.title = "Welcome Thai Ginger!!"
            
            setUserInteractionForButtons(value: true)
        }
            
        else if(Utility.className == Utility.myDonations && (donationDict?["donationStatus"]as?String == Utility.ACCEPTED)){
            actionButton.isHidden = true
            cancelButton.setTitle("cancel", for: UIControlState.normal)
            
            //show navigation controller for view Donation details page
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            // Status bar black font
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.title = "Welcome Thai Ginger!!"
            setUserInteractionForButtons(value: false)
        }
        
        else if(Utility.className == Utility.availableDonations){
            
            actionButton.isHidden = false
            actionButton.setTitle("Reserve", for: UIControlState.normal)
            
            //show navigation controller for view Donation details page
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            // Status bar black font
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.title = "Welcome Thai Ginger!!"
            
            setUserInteractionForButtons(value: false)
            
        }
        
        //Set value for Donation Details page
        foodDescTextView.text = donationDict?["foodDesc"] as? String
        splInstTextView.text = donationDict?["splInstructions"] as? String
        zipcodeTextField.text = donationDict?["zipcode"] as? String
        stateTextField.text = donationDict?["state"] as? String
        cityTextField.text =  donationDict?["city"] as? String
        address2TextField.text = donationDict?["address2"] as? String
        address1TextField.text = donationDict?["address1"] as? String
        contactTextField.text = donationDict?["contact"] as? String
        qtyTextField.text = donationDict?["quantity"] as? String
        toDateTextField.text = donationDict?["pickUpToDate"] as? String
        fromDateTextField.text = donationDict?["pickUpFromDate"] as? String
        donationTitleTextField.text = donationDict?["donationTitle"] as? String
        
    }
    
    //MARK: IBAction Methods
    //Show Date and time picker for fromDate text field
    @IBAction func fromDateTextFieldAction(_ sender: UITextField) {
        //Create the view
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        inputView.addSubview(datePickerView) // add date picker to UIView
        datePickerView.addTarget(self, action: #selector(fromDatePickerValueChanged), for: UIControlEvents.valueChanged)
        inputView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[datePickerView]|", options: .alignAllFirstBaseline, metrics: nil, views: ["datePickerView":datePickerView]))
        inputView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[datePickerView]-|", options: .alignAllFirstBaseline, metrics: nil, views: ["datePickerView":datePickerView]))
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
    
    @IBAction func actionButtonAction(_ sender: Any) {
        
        if(Utility.className == Utility.myDonations && (donationDict?["donationStatus"]as?String == Utility.NEW)){
            let webSerV: Webservice = Webservice()
            webSerV.updateDonationsDelegate = self
            webSerV.updateDonationDetailsToFireBaseDatabase(foodDesc: foodDescTextView.text, quantity: qtyTextField.text!, contact: contactTextField.text!, address1: address1TextField.text!, address2: address2TextField.text!, city: cityTextField.text!, state: stateTextField.text!, zipcode: zipcodeTextField.text!, splInstructions: splInstTextView.text!, pickUpFromDate: fromDateTextField.text!, pickUpToDate: toDateTextField.text!, donationID: donationID ,donationTitle:donationTitleTextField.text!)
            
        }
        else if(Utility.className == Utility.availableDonations){
            let webSerV: Webservice = Webservice()
            webSerV.reserveAvailableDonationsDelegate = self
            webSerV.reserveAvailableDonations(donationID: donationID,status:Utility.PENDINGAPPROVAL)
        }
        
        else if(Utility.className == Utility.myDonations && (donationDict?["donationStatus"]as?String == Utility.PENDINGAPPROVAL)){
            let webSerV: Webservice = Webservice()
            webSerV.reserveAvailableDonationsDelegate = self
            webSerV.reserveAvailableDonations(donationID: donationID,status:Utility.ACCEPTED)
            
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        if(Utility.className == Utility.myDonations && (donationDict?["donationStatus"]as?String == Utility.PENDINGAPPROVAL)){
            let webSerV: Webservice = Webservice()
            webSerV.reserveAvailableDonationsDelegate = self
            webSerV.reserveAvailableDonations(donationID: donationID,status:Utility.NEW)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    //MARK: updateDonationDetailsProtocol Methods
    func updateDonationSuccessful(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateDonationUnSuccessful(error:Error){
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: reserveAvailableDonationsProtocol Methods
    func reserveAvailableDonationSuccessful(){
        self.dismiss(animated: true, completion: nil)
        OneSignal.postNotification(["contents": ["en":"Test Message"],"include_player_ids": donationDict!["signalIds"] as! [String]], onSuccess: { (successDict) in
            debugPrint(successDict)
        }) { (error) in
            debugPrint(error)
        }
        
    }
    func reserveAvailableUnSuccessful(error:Error){
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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
    func fromDoneButtonAction(sender:UIButton) {
        fromDateTextField.resignFirstResponder()
    }
    //Dismiss date picker view
    func toDoneButtonAction(sender:UIButton)
    {
        toDateTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    //Set the Date format for Datepicker
    func datePickerValuechanged(sender:UIDatePicker) -> String {
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
    
    func setUserInteractionForButtons(value:Bool){
        foodDescTextView.isUserInteractionEnabled = value
        splInstTextView.isUserInteractionEnabled = value
        zipcodeTextField.isUserInteractionEnabled = value
        stateTextField.isUserInteractionEnabled = value
        cityTextField.isUserInteractionEnabled = value
        address2TextField.isUserInteractionEnabled = value
        address1TextField.isUserInteractionEnabled = value
        contactTextField.isUserInteractionEnabled = value
        qtyTextField.isUserInteractionEnabled = value
        toDateTextField.isUserInteractionEnabled = value
        fromDateTextField.isUserInteractionEnabled = value
        donationTitleTextField.isUserInteractionEnabled = value
    }

}
