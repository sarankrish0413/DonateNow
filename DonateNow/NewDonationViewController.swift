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



class NewDonationViewController: UIViewController,newDonationProtocol,UITextFieldDelegate,UITextViewDelegate{
    
    
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
    
    @IBOutlet weak var donationTitleTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    
    var activityIndicator:UIActivityIndicatorView!
    
    
    
    //MARK: View Controller Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Clear all the values
        donationTitleTextField.text = ""
        foodDescTextView.text = ""
        qtyTextField.text = ""
        contactTextField.text = ""
        zipcodeTextField.text = ""
        stateTextField.text = ""
        cityTextField.text = ""
        address2TextField.text = ""
        address1TextField.text = ""
        splInstTextView.text = ""
        fromDateTextField.text = ""
        toDateTextField.text = ""

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
        
        //show activity inidcator view
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
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
    
   
    //MARK: Outlets Action
    //Add Button, capture all the details from form and add it to Donations array
    @IBAction func addButtonAction(_ sender: UIButton) {
        let uuid = UUID().uuidString
        let webSerV: Webservice = Webservice()
        webSerV.newDonationDelegate = self;
        webSerV.addDonationDetailsToFireBaseDatabase(foodDesc: foodDescTextView.text, quantity: qtyTextField.text!, contact: contactTextField.text!, address1: address1TextField.text!, address2: address2TextField.text!, city: cityTextField.text!, state: stateTextField.text!, zipcode: zipcodeTextField.text!, splInstructions: splInstTextView.text!, createdUserID: Utility.userID!, createdDate: getCurrentDateAndTime(), pickUpFromDate: fromDateTextField.text!, pickUpToDate: toDateTextField.text!, donationID: uuid , donationStatus: Utility.NEW,donationTitle:donationTitleTextField.text!,restaurantName: Utility.restaurantName!,requestorUserID:"'")
        
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
    
    //MARK WebserviceProtocol Methods
    func newDonationSuccessful(){
        activityIndicator.stopAnimating()
        self.tabBarController?.selectedIndex = 0;
        
    }
    func newDonationUnSuccessful(error:Error){
        activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK Keyboard show/hide Methods
    //Show keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == address1TextField || textField == address2TextField || textField == cityTextField || textField == stateTextField || textField == zipcodeTextField {
            animateViewMoving(up: true, moveValue: 150)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == address1TextField || textField == address2TextField || textField == cityTextField || textField == stateTextField || textField == zipcodeTextField {
            animateViewMoving(up: false, moveValue: 150)
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    //MARK:UITextView Delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == splInstTextView {
            animateViewMoving(up: true, moveValue: 150)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == splInstTextView {
            animateViewMoving(up: false, moveValue: 150)
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
