//  DetailViewController.swift
//  Travel_N_Earn_Demo
//
//  Created by Vinayak Balaji Tuptewar on 02/06/20.
//  Copyright © 2020 Vinayak Balaji Tuptewar. All rights reserved.
//

import UIKit
import SQLite3

class DetailViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var travellertv: UITextView!
    @IBOutlet weak var mobiletv: UITextView!
    @IBOutlet weak var boardingtv: UITextView!
    @IBOutlet weak var landingtv: UITextView!
    @IBOutlet weak var date1tv: UITextView!
    @IBOutlet weak var date2tv: UITextView!
    @IBOutlet weak var weighttv: UITextView!
    @IBOutlet weak var addresstv: UITextView!
    @IBOutlet weak var updatebtn: UIButton!
    @IBOutlet weak var deletebtn: UIButton!
    
    var username = ""
    
    var strtraveller = ""
    var strmobile = ""
    var strboardinf = ""
    var strlanding = ""
    var strdate1 = ""
    var strdate2 = ""
    var strdoubleWeight = 0.0
    var straddress = ""
    
    var toolbar = UIToolbar()
    var pickerV1 = UIPickerView()
    var pickerV2 = UIPickerView()
    var datePickerV1 = UIDatePicker()
    var datePickerV2 = UIDatePicker()
    
    var activeTV = UITextView()
    
    var tempModel:Model?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFunctionality()
    }
    
    
    
    //MARK:View_Functionality function
    func viewFunctionality(){
        textView_cornerRadius(textView: travellertv)
        textView_cornerRadius(textView: mobiletv)
        textView_cornerRadius(textView: boardingtv)
        textView_cornerRadius(textView: landingtv)
        textView_cornerRadius(textView: weighttv)
        textView_cornerRadius(textView: addresstv)
        textView_cornerRadius(textView: date1tv)
        textView_cornerRadius(textView: date2tv)
        
        username = self.tempModel!.uniqueUsername
        travellertv.text = self.tempModel?.fullname
        mobiletv.text = self.tempModel?.mobile
        boardingtv.text = self.tempModel?.country1
        landingtv.text = self.tempModel?.country2
        date1tv.text = self.tempModel?.date1
        date2tv.text = self.tempModel?.date1
        weighttv.text = String.init(self.tempModel!.weight)
        addresstv.text = self.tempModel?.addressExtra
        
        if LoginViewController.uniqueUsername != username{
            updatebtn.isHidden = true
            deletebtn.isHidden = true
            
            travellertv.isEditable = false
            mobiletv.isEditable = false
            boardingtv.isEditable = false
            landingtv.isEditable = false
            date1tv.isEditable = false
            date2tv.isEditable = false
            weighttv.isEditable = false
            addresstv.isEditable = false
            
            boardingtv.isSelectable = false
            landingtv.isSelectable = false
            date1tv.isSelectable = false
            date2tv.isSelectable = false
        }else{
            updatebtn.isHidden = false
            deletebtn.isHidden = false
            
            travellertv.isEditable = true
            mobiletv.isEditable = true
            boardingtv.isEditable = true
            landingtv.isEditable = true
            date1tv.isEditable = true
            date2tv.isEditable = true
            weighttv.isEditable = true
            addresstv.isEditable = true
            
            boardingtv.isSelectable = true
            landingtv.isSelectable = true
            date1tv.isSelectable = true
            date2tv.isSelectable = true
        }
        
        travellertv.delegate = self
        mobiletv.delegate = self
        boardingtv.delegate = self
        landingtv.delegate = self
        date1tv.delegate = self
        date2tv.delegate = self
        weighttv.delegate = self
        addresstv.delegate = self
        
        pickerV1.tag = 1
        pickerV2.tag = 2
        datePickerV1.tag = 1
        datePickerV2.tag = 2
        
        date1tv.tag = 1
        date2tv.tag = 2
    }
    
    
    
    
    //MARK:Update_click function
    @IBAction func updateClick(_ sender: Any) {
        
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbpath = url.appendingPathComponent("TravelN.sqlite")
        var ptr:OpaquePointer?
        
        var weight = String()
        if weighttv.text != ""{
            weight = weighttv.text
        }else{
            weight = "0.0"
        }
        
        if travellertv.text! != "" && mobiletv.text! != ""{
            if sqlite3_open(dbpath.path, &ptr)==SQLITE_OK{
                let query = "update data set traveller = '\(travellertv.text! != "" ? travellertv.text! : "Not provided")',mobile = '\(mobiletv.text! != "" ? mobiletv.text! : "Not provided")',boardingcountry = '\(boardingtv.text! != "" ? boardingtv.text! : "Not provided")',landingcountry = '\(landingtv.text! != "" ? landingtv.text! : "Not provided")',boardingdate = '\(date1tv.text! != "" ? date1tv.text! : "Not provided")',landingdate = '\(date2tv.text! != "" ? date2tv.text! : "Not provided")',weight = \(weight),address = '\(addresstv.text! != "" ? addresstv.text! : "Not provided")'where username = '\(LoginViewController.uniqueUsername)'"
                print(query)
                if sqlite3_exec(ptr, query, nil, nil, nil)==SQLITE_OK{
                    print("updated")
                }else{
                    print("fail to update")
                }
            }else{
                print("fail to open database")
            }
            sqlite3_close(ptr)
            self.navigationController?.popViewController(animated: true)
            
        }else{
            self.showAlert(title: "Alert", message: "Traveller name and mobile number is mandatory.")
        }
    }
    
    
    
    
    //MARK: delete_click function
    @IBAction func deleteClick(_ sender: Any) {
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbpath = url.appendingPathComponent("TravelN.sqlite")
        var ptr:OpaquePointer?
        
        if sqlite3_open(dbpath.path, &ptr)==SQLITE_OK{
            let query = "delete from data where username = '\(LoginViewController.uniqueUsername)'"
            //            print(query)
            if sqlite3_exec(ptr, query, nil, nil, nil)==SQLITE_OK{
                print("deleted")
            }else{
                print("fail to delete")
            }
        }else{
            print("fail to open database")
        }
        sqlite3_close(ptr)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}




//MARK: PickerView delegate datasource
extension DetailViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    override func viewDidAppear(_ animated: Bool) {
        
        pickerV1.delegate = self
        pickerV2.delegate = self
        
        toolbar.sizeToFit()
        let donebtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnClick))
        toolbar.setItems([donebtn], animated: true)
        
        boardingtv.inputView = pickerV1
        boardingtv.inputAccessoryView = toolbar
        landingtv.inputView = pickerV2
        landingtv.inputAccessoryView = toolbar
        
        date1tv.inputView = datePickerV1
        date1tv.inputAccessoryView = toolbar
        date2tv.inputView = datePickerV2
        date2tv.inputAccessoryView = toolbar
        
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTV = textView
    }
    
    
    
    
    @objc func doneBtnClick(){
        
        if activeTV.tag == 1{
            datePickerV1.datePickerMode = .dateAndTime
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .short
            print("date1 = ",df.string(from: datePickerV1.date))
            date1tv.text = df.string(from: datePickerV1.date)
        }else if activeTV.tag == 2{
            datePickerV2.datePickerMode = .dateAndTime
            let df2 = DateFormatter()
            df2.dateStyle = .medium
            df2.timeStyle = .short
            print("date2 = ",df2.string(from: datePickerV2.date))
            date2tv.text = df2.string(from: datePickerV2.date)
        }
        view.endEditing(true)
    }
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1{
            return 1
        }else if pickerView.tag == 2{
            return 1
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return AddViewController.countryArray.count
        }else if pickerView.tag == 2{
            return AddViewController.countryArray.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1{
            return AddViewController.countryArray[row]
        }else if pickerView.tag == 2{
            return AddViewController.countryArray[row]
        }
        return "Error"
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            boardingtv.text = AddViewController.countryArray[row]
        }else if pickerView.tag == 2{
            landingtv.text = AddViewController.countryArray[row]
        }
    }
}





