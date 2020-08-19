//
//  AddViewController.swift
//  Travel_N_Earn_Demo
//
//  Created by Vinayak Balaji Tuptewar on 31/05/20.
//  Copyright © 2020 Vinayak Balaji Tuptewar. All rights reserved.
//

import UIKit
import SQLite3

class AddViewController: UIViewController {
    @IBOutlet weak var travellertf: UITextField!
    @IBOutlet weak var mobiletf: UITextField!
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var picker2: UIPickerView!
    @IBOutlet weak var datepicker1: UIDatePicker!
    @IBOutlet weak var datepicker2: UIDatePicker!
    @IBOutlet weak var availableWeighttf: UITextField!
    @IBOutlet weak var addressExtratf: UITextField!
    @IBOutlet weak var savebtn: UIButton!
    
    static var countryArray:[String] = ["Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua &amp; Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia &amp; Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre &amp; Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts &amp; Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad &amp; Tobago","Tunisia","Turkey","Turkmenistan","Turks &amp; Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]
    
    var selectedCountry1 = "Not Provided"
    var selectedCountry2 = "Not Provided"
    
    var alert = UIAlertController()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFunctionality()
    }
    
    
    
    
    //MARK: view functionality
    func viewFunctionality(){
        picker1.tag = 1
        picker2.tag = 2
        self.picker1.delegate = self
        self.picker1.dataSource = self
        self.picker2.delegate = self
        self.picker2.delegate = self
        picker1.layer.borderWidth = 1
        picker1.layer.cornerRadius = picker1.frame.size.height/4
        picker2.layer.borderWidth = 1
        picker2.layer.cornerRadius = picker2.frame.size.height/4
        
        textField_cornerRadius(textField: travellertf)
        textField_cornerRadius(textField: mobiletf)
        textField_cornerRadius(textField: availableWeighttf)
        textField_cornerRadius(textField: addressExtratf)
        
        datepicker1.layer.borderWidth = 1
        datepicker1.layer.cornerRadius = datepicker1.frame.size.height/4
        datepicker2.layer.borderWidth = 1
        datepicker2.layer.cornerRadius = datepicker2.frame.size.height/4
    }
    
    
    
    
    //MARK: get_country_names_API function
    func getCountryNamesFromAPI(){
        
        let urlrequest = URLRequest(url: URL(string: "https://restcountries.eu/rest/v2/all")!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlrequest) { (data, response, error) in
            print(data!)
           
            guard let data = data else{ return }
            
            do{
                let outerarray = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)as! NSArray
                
                for item in outerarray{
                    let dic = item as! NSDictionary
                    let name = dic.value(forKey: "name")as! String
                    AddViewController.countryArray.append(name)
                    
                    DispatchQueue.main.async {
                        self.picker1.reloadAllComponents()
                        self.picker2.reloadAllComponents()
                    }
                }
            }
            catch let error{
                print("error \(String(describing: error))")
            }
        }
        task.resume()
    }
    
    
    
    
    //MARK: button_click functionality
    @IBAction func btnclicked(_ sender: Any) {
        
        datepicker1.datePickerMode = .dateAndTime
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        let date1 = df.string(from: datepicker1.date)
        //        print(date1)
        
        datepicker2.datePickerMode = .dateAndTime
        let df2 = DateFormatter()
        df2.dateStyle = .medium
        df2.timeStyle = .short
        let date2 = df2.string(from: datepicker2.date)
        //        print(date2)
        
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbpath = url.appendingPathComponent("TravelN.sqlite")
        var ptr:OpaquePointer?
        
        if travellertf.text! != "" && mobiletf.text! != ""{
            if sqlite3_open(dbpath.path, &ptr)==SQLITE_OK{
                
                let query = String(format: "insert into data values('%@','%@','%@','%@','%@','%@','%@',%f,'%@')","\(LoginViewController.uniqueUsername)",travellertf.text!,mobiletf.text!,"\(selectedCountry1)","\(selectedCountry2)","\(date1)","\(date2)",Float((availableWeighttf.text!)) ?? 0.0,addressExtratf.text! != "" ? addressExtratf.text! : "Not Provided")
                
                if sqlite3_exec(ptr, query, nil, nil, nil) == SQLITE_OK{
                    print(query)
                    print("inserted")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    
                    print("fail to insert")
                }
            }else{
                print("fail to open database")
            }
            sqlite3_close(ptr)
        }else{
            alert = UIAlertController(title: "Alert", message: "Traveller name and mobile number is mandatory.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            }))
            present(alert, animated: true, completion: nil)
            print("Traveller name and mobile number is mandatory.")
        }
    }
}




//MARK: PickeView delegate datasource
extension AddViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
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
        return 10
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return AddViewController.countryArray[row]
        }else if pickerView.tag == 2{
            return AddViewController.countryArray[row]
        }
        return "none"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            selectedCountry1=AddViewController.countryArray[row]
            print("selected1 = ",selectedCountry1)
        }
        if pickerView.tag == 2{
            selectedCountry2 = AddViewController.countryArray[row]
            print("selected2 = ",selectedCountry2)
        }
    }
    
}




extension AddViewController:UITextFieldDelegate{
    override func viewDidAppear(_ animated: Bool) {
        travellertf.delegate = self
        mobiletf.delegate = self
        addressExtratf.delegate = self
        availableWeighttf.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}
