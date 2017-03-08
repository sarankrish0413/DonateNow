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
import FirebaseAnalytics


class ViewDonationDetailsViewController: UIViewController,updateDonationDetailsProtocol,updateDonationStatusProtocol,UITextFieldDelegate,UITextViewDelegate{
    
    
    var donationDetails: Dictionary<String, Any>!
    var donationID: String!
    var donationDict: Dictionary<String, Any>!
    var status: String!
    
    
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
        foodDescTextView.layer.borderWidth = 1.0
        foodDescTextView.layer.cornerRadius = 5.0
        foodDescTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        //Draw border for Special instruction textview
        splInstTextView.layer.borderWidth = 1.0
        splInstTextView.layer.cornerRadius = 5.0
        splInstTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let itemsDict = donationDetails?[donationID] as! Dictionary<String,Any>! {
            donationDict = itemsDict
        }
        
        if let value = donationDict?["donationStatus"] as! String! {
            status = value
        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true)
        // Status bar black font
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let charityNameString = "Welcome " + Utility.charityName! + "!!"
        self.title = charityNameString
        
        //Disable user interaction if it is from accepted donation page
        //Requestor accepted Donations
        if Utility.userType == Utility.REQUESTOR && (status == Utility.ACCEPTED){
            actionButton.isHidden = true
            setUserInteractionForButtons(value: false)
            //show navigation controller for view Donation details page
            
        }
            //Donor update donations
        else if(Utility.userType == Utility.DONOR && (status == Utility.NEW) ){
            actionButton.isHidden = false
            actionButton.setTitle("UPDATE", for: UIControlState.normal)
            //show navigation controller for view Donation details page
            setUserInteractionForButtons(value: true)
        }
            //Donor Approve / Reject Donations
        else if(Utility.userType == Utility.DONOR && (status == Utility.PENDINGAPPROVAL)){
            actionButton.isHidden = false
            actionButton.setTitle("APPROVE", for: UIControlState.normal)
            cancelButton.setTitle("REJECT", for: UIControlState.normal)
            //show navigation controller for view Donation details page
            setUserInteractionForButtons(value: true)
        }
            //Donor view accepted donation details
        else if(Utility.userType == Utility.DONOR && (status == Utility.ACCEPTED)){
            actionButton.isHidden = true
            cancelButton.setTitle("CANCEL", for: UIControlState.normal)
            //show navigation controller for view Donation details page
            setUserInteractionForButtons(value: false)
        }
            //Requestor reserve available donation
        else if(Utility.userType == Utility.REQUESTOR && (status == Utility.NEW)){
            if let donationRejectors = donationDict["rejectedUserIds"] as? [String], let userId = Utility.userID, donationRejectors.contains(userId) {
                actionButton.isHidden = true
                actionButton.setTitle("RESERVE", for: UIControlState.normal)
                //show navigation controller for view Donation details page
                setUserInteractionForButtons(value: false)
            }else {
                actionButton.isHidden = false
                setUserInteractionForButtons(value: false)
            }
        }
        else {
            actionButton.isHidden = true
        }
        setDonationDetails()
        
        //set delegates for text field
        donationTitleTextField.delegate = self
        foodDescTextView.delegate = self
        qtyTextField.delegate = self
        contactTextField.delegate = self
        zipcodeTextField.delegate = self
        stateTextField.delegate = self
        cityTextField.delegate = self
        address2TextField.delegate = self
        address1TextField.delegate = self
        splInstTextView.delegate = self
        
        //--- add UIToolBar on keyboard and Done button on UIToolBar ---//
        self.addDoneButtonOnKeyboard()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        foodDescTextView.setContentOffset(CGPoint.zero, animated: false)
        splInstTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //set Donation Details value in the UI
    func setDonationDetails() {
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
    
    
    //MARK: Adding Done button to key board
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SignupDonorViewController.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        contactTextField.inputAccessoryView = doneToolbar
        zipcodeTextField.inputAccessoryView = doneToolbar
        qtyTextField.inputAccessoryView = doneToolbar
        
        
    }
    
    func doneButtonAction()
    {
        contactTextField.resignFirstResponder()
        zipcodeTextField.resignFirstResponder()
        qtyTextField.resignFirstResponder()
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
        //From Donor New Donation Click on add button
        if(Utility.userType == Utility.DONOR && (status == Utility.NEW)){
            let webSerV: Webservice = Webservice()
            webSerV.updateDonationsDelegate = self
            webSerV.updateDonationDetailsToFireBaseDatabase(foodDesc: foodDescTextView.text, quantity: qtyTextField.text!, contact: contactTextField.text!, address1: address1TextField.text!, address2: address2TextField.text!, city: cityTextField.text!, state: stateTextField.text!, zipcode: zipcodeTextField.text!, splInstructions: splInstTextView.text!, pickUpFromDate: fromDateTextField.text!, pickUpToDate: toDateTextField.text!, donationID: donationID ,donationTitle:donationTitleTextField.text!)
        }
            //From Requestor Available Donation to reserve for Donations
        else if(Utility.userType == Utility.REQUESTOR && (status == Utility.NEW)){
            let webSerV: Webservice = Webservice()
            webSerV.updateDonationStatusDelegate = self
            var requestorSignalIds = [String]()
            if let signalId = oneSignalUserData.userId {
                requestorSignalIds.append(signalId)
            }
            webSerV.updateDonationStatus(donationID: donationID,status:Utility.PENDINGAPPROVAL,requestorID:Utility.userID!,requestorSignalIds: requestorSignalIds,rejectedUserIds: [String]())
        }
            //From Donor My Donations to Accept the requestor request
        else if(Utility.userType == Utility.DONOR && (status == Utility.PENDINGAPPROVAL)){
            let webSerV: Webservice = Webservice()
            webSerV.updateDonationStatusDelegate = self
            var requestorSignalIds = [String]()
            if let signalId = oneSignalUserData.userId {
                requestorSignalIds.append(signalId)
            }
            webSerV.updateDonationStatus(donationID: donationID,status:Utility.ACCEPTED,requestorID:(donationDict?["requestorUserID"]as?String)!,requestorSignalIds: requestorSignalIds,rejectedUserIds: [String]())
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        //From Donor My Donations to reject the requestor request
        if(Utility.userType == Utility.DONOR && (status == Utility.PENDINGAPPROVAL)){
            let webSerV: Webservice = Webservice()
            webSerV.updateDonationStatusDelegate = self
            var requestorSignalIds = [String]()
            if let signalId = oneSignalUserData.userId {
                requestorSignalIds.append(signalId)
            }
            var rejectedUserIds = [String]()
            if let signalIds = donationDict?["requestorUserID"] as! String! {
                rejectedUserIds.append(signalIds)
            }
            webSerV.updateDonationStatus(donationID: donationID,status:Utility.REJECTED,requestorID:"",requestorSignalIds: requestorSignalIds ,rejectedUserIds:rejectedUserIds)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: updateDonationDetailsProtocol Methods
    func updateDonationSuccessful(){
        //Firebase Analytics
        FIRAnalytics.logEvent(withName: "update_donation", parameters: [
            "userID": Utility.userID! as String as NSObject,
            "donationID": donationID as String as NSObject
            ])
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateDonationUnSuccessful(error:Error){
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: reserveAvailableDonationsProtocol Methods
    func updateDonationStatusSuccessful(status:String){
        self.dismiss(animated: true, completion: nil)
        if Utility.userType == Utility.REQUESTOR && status == Utility.PENDINGAPPROVAL {
            //Firebase Analytics
            FIRAnalytics.logEvent(withName: "requestor_request_donation", parameters: [
                "userID": Utility.userID! as String as NSObject,
                "donationID": donationID as String as NSObject
                ])
            let notificationMessage = "You have received Approval request from " + Utility.charityName! + "."
            OneSignal.postNotification(["contents": ["en":notificationMessage],"include_player_ids": donationDict!["signalIds"] as! [String]], onSuccess: { (successDict) in
                debugPrint("sucseesDict:",successDict!)
            }) { (error) in
                debugPrint(error!)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else if Utility.userType == Utility.DONOR && status == Utility.ACCEPTED {
            //Firebase Analytics
            FIRAnalytics.logEvent(withName: "donor_accepts_request", parameters: [
                "userID": Utility.userID! as String as NSObject,
                "donationID": donationID as String as NSObject
                ])
            let notificationMessage = "You request has been approved by " + Utility.restaurantName! + "."
            OneSignal.postNotification(["contents": ["en":notificationMessage],"include_player_ids": donationDict!["requestorSignalIds"] as! [String]], onSuccess: { (successDict) in
                debugPrint("sucseesDict:",successDict!)
            }) { (error) in
                debugPrint(error!)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else if Utility.userType == Utility.DONOR && status == Utility.REJECTED {
            //Firebase Analytics
            FIRAnalytics.logEvent(withName: "donor_rejects_request", parameters: [
                "userID": Utility.userID! as String as NSObject,
                "donationID": donationID as String as NSObject
                ])
            let notificationMessage = "You request has been Rejected by " + Utility.restaurantName! + "."
            OneSignal.postNotification(["contents": ["en":notificationMessage],"include_player_ids": donationDict!["requestorSignalIds"] as! [String]], onSuccess: { (successDict) in
                debugPrint("sucseesDict:",successDict!)
            }) { (error) in
                debugPrint(error!)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    func updateDonationStatusUnSuccessful(error:Error){
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
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone!
        let dateFromString = dateFormatter.string(from: sender.date )
        return dateFromString
    }
    
    //Set User Interactions for button
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
    
    //MARK Keyboard show/hide Methods
    //Show keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == address1TextField || textField == address2TextField || textField == cityTextField || textField == stateTextField || textField == zipcodeTextField {
            self.view.animateViewMoving(up: true, moveValue: 200)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == address1TextField || textField == address2TextField || textField == cityTextField || textField == stateTextField || textField == zipcodeTextField {
            self.view.animateViewMoving(up: false, moveValue: 200)
        }
    }
    
    //MARK:UITextView Delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == splInstTextView {
            self.view.animateViewMoving(up: true, moveValue: 200)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == splInstTextView {
            self.view.animateViewMoving(up: false, moveValue: 200)
        }
    }
    
    //MARK:Text Field Delegate methods
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:Text view Delegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}


