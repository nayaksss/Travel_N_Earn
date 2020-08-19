//
//  SignupViewController.swift
//  Travel_N_Earn_Demo
//
//  Created by Vinayak Balaji Tuptewar on 30/05/20.
//  Copyright © 2020 Vinayak Balaji Tuptewar. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var fullnametf: UITextField!
    @IBOutlet weak var mobilenotf: UITextField!
    @IBOutlet weak var emailtf: UITextField!
    @IBOutlet weak var usernametf: UITextField!
    @IBOutlet weak var passwordtf: UITextField!
    @IBOutlet weak var re_enterePasswordtf: UITextField!
    @IBOutlet weak var signup: UIButton!
    
    var tempUsername = String()
//    var alert = UIAlertController()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFunctionality()
    }
    
    
    
    //MARK: View functioanlity
    func viewFunctionality(){
        textField_cornerRadius(textField: fullnametf)
        textField_cornerRadius(textField: mobilenotf)
        textField_cornerRadius(textField: emailtf)
        textField_cornerRadius(textField: usernametf)
        textField_cornerRadius(textField: passwordtf)
        textField_cornerRadius(textField: re_enterePasswordtf)
    }
    
    
    
    
    //MARK: SignUp functionality
    @IBAction func signupclicked(_ sender: Any) {
        
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbpath = url.appendingPathComponent("LoginSignup.plist")
        let dic = NSMutableDictionary(contentsOfFile: dbpath.path)
        
        //        var tempDictionary = NSMutableDictionary()
        //        tempDictionary.setValue(fullnametf.text!, forKey: "fullName")
        //        tempDictionary.setValue(mobilenotf.text!, forKey: "mobileNumber")
        //        tempDictionary.setValue(emailtf.text!, forKey: "email")
        //        tempDictionary.setValue(usernametf.text!, forKey: "username")
        //        tempDictionary.setValue(passwordtf.text!, forKey: "password")
        //        tempDictionary.setValue(re_enterePasswordtf.text!, forKey: "reenterPassword")
        //        dic?.setValue(tempDictionary, forKey: "\(usernametf.text!)")
        
        
        if fullnametf.text! != "" && mobilenotf.text! != "" && emailtf.text! != "" && usernametf.text! != "" && passwordtf.text! != "" && re_enterePasswordtf.text! != ""{
            
            // if usename already taken
            if dic!.count > 0{
                if let tempMainArray = dic!.value(forKey: "\(usernametf.text!)"){
                    let tempArray = tempMainArray as! NSArray
                    tempUsername = tempArray[3]as! String
                }
            }
            
            if usernametf.text! != tempUsername{
                if passwordtf.text! == re_enterePasswordtf.text!{
                    let temparray = NSMutableArray()
                    temparray.add(fullnametf.text!)
                    temparray.add(mobilenotf.text!)
                    temparray.add(emailtf.text!)
                    temparray.add(usernametf.text!)
                    temparray.add(passwordtf.text!)
                    
                    dic?.setValue(temparray, forKey: "\(usernametf.text!)")
                    dic?.write(to: dbpath, atomically: true)
                    
                    LoginViewController.uniqueUsername = "\(usernametf.text!)"
                    
                    let tablevc = TableViewController()
                    self.navigationController?.pushViewController(tablevc, animated: true)
                    
                    print(dic!)
                    
                }else{
                    self.showAlert(title: "Alert", message: "Password does not match.")
                }
                
            }else{
                self.showAlert(title: "Alert", message: "username already taken. Create unique username.")
            }
            
        }else{
            self.showAlert(title: "Alert", message: "All fields are mandatory.")
        }
    }
}




extension SignupViewController:UITextFieldDelegate{
    override func viewDidAppear(_ animated: Bool) {
        fullnametf.delegate = self
        mobilenotf.delegate = self
        emailtf.delegate = self
        usernametf.delegate = self
        passwordtf.delegate = self
        re_enterePasswordtf.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}
