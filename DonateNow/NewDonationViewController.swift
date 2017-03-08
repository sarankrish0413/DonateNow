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
import SkyFloatingLabelTextField
import FirebaseAnalytics


class NewDonationViewController: UIViewController,newDonationProtocol,UITextFieldDelegate,UITextViewDelegate{
    
    
    //MARK: Outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var foodDescTextView: UITextView!
    @IBOutlet weak var splInstTextView: UITextView!
    @IBOutlet weak var zipcodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var address2TextField: SkyFloatingLabelTextField!
    @IBOutlet weak var address1TextField: SkyFloatingLabelTextField!
    @IBOutlet weak var contactTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var qtyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var donationTitleTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var toDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var fromDateTextField: SkyFloatingLabelTextField!
    
    var activityIndicator: UIActivityIndicatorView!
    var uuid: String!
    
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase Analytics
        FIRAnalytics.logEvent(withName: "donor_new_donation", parameters: [
            "userID": Utility.userID! as String as NSObject,
            ])

        //Draw border for Food description textview
        foodDescTextView.layer.borderWidth = 1.0
        foodDescTextView.layer.cornerRadius = 5.0
        foodDescTextView.layer.borderColor = UIColor.lightGray.cgColor

        
        //Draw border for Special instruction textview
        splInstTextView.layer.borderWidth = 1.0
        splInstTextView.layer.cornerRadius = 5.0
        splInstTextView.layer.borderColor = UIColor.lightGray.cgColor
    
        //Draw border for Add donations Button
        addButton.layer.cornerRadius = 19
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.clear.cgColor
        
        //show activity inidcator view
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Clear all the values
        donationTitleTextField.text = ""
        foodDescTextView.text = ""
        qtyTextField.text = ""
        contactTextField.text = Utility.contact
        zipcodeTextField.text = Utility.zipCode
        stateTextField.text = Utility.state
        cityTextField.text = Utility.city
        address2TextField.text = Utility.address2
        address1TextField.text = Utility.address1
        splInstTextView.text = ""
        fromDateTextField.text = ""
        toDateTextField.text = ""

}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        foodDescTextView.setContentOffset(CGPoint.zero, animated: false)
        splInstTextView.setContentOffset(CGPoint.zero, animated: false)
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
   
    //MARK: Outlets Action
    //Add Button, capture all the details from form and add it to Donations array
    @IBAction func addButtonAction(_ sender: UIButton) {
        
        let dateStart = convertStringToDate(dateString: fromDateTextField.text!)
        let dateEnd = convertStringToDate(dateString: toDateTextField.text!)
        if dateStart.compare(dateEnd) == .orderedDescending || dateStart.compare(dateEnd) == .orderedSame {
            let alertController = UIAlertController(title: "Error", message: "To Date should be greater than From Date!!!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if dateStart.compare(dateEnd) == .orderedAscending {
            uuid = UUID().uuidString
            let webSerV: Webservice = Webservice()
            webSerV.newDonationDelegate = self
            webSerV.addDonationDetailsToFireBaseDatabase(foodDesc: foodDescTextView.text, quantity: qtyTextField.text!, contact: contactTextField.text!, address1: address1TextField.text!, address2: address2TextField.text!, city: cityTextField.text!, state: stateTextField.text!, zipcode: zipcodeTextField.text!, splInstructions: splInstTextView.text!, createdUserID: Utility.userID!, createdDate: getCurrentDateAndTime(), pickUpFromDate: fromDateTextField.text!, pickUpToDate: toDateTextField.text!, donationID: uuid , donationStatus: Utility.NEW,donationTitle:donationTitleTextField.text!,restaurantName: Utility.restaurantName!,requestorUserID:"'")
        }
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
        //Date Format for UI
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone!
        let dateFromString = dateFormatter.string(from: sender.date )
        return dateFromString
    }
    
    
    func getCurrentDateAndTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone!
        let dateFromString = dateFormatter.string(from:NSDate() as Date)
        return dateFromString
    }
    
    //MARK WebserviceProtocol Methods
    func newDonationSuccessful(){
        //Firebase Analytics
        FIRAnalytics.logEvent(withName: "new_donation", parameters: [
            "userID": Utility.userID! as String as NSObject,
            "donationID": uuid as String as NSObject
            ])
        
        self.dismiss(animated: true, completion: nil)
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.tabBarController?.selectedIndex = 0
        
    }
    func newDonationUnSuccessful(error:Error){
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
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
            textView.layoutIfNeeded()
            return false
        }
        return true
    }
    
    //Convert String to Date
    func convertStringToDate(dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone!
        let date = dateFormatter.date(from: dateString)
        return date!
    }
   
}

extension UIView {
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        frame = frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
}


