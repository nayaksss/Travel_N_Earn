//
//  LoginViewController.swift
//  Travel_N_Earn_Demo
//
//  Created by Vinayak Balaji Tuptewar on 30/05/20.
//  Copyright © 2020 Vinayak Balaji Tuptewar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernametf: UITextField!
    @IBOutlet weak var passwordtf: UITextField!
    
    static var uniqueUsername = ""
//    var alert = UIAlertController()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFunctionality()
    }
    
    
    
    
    //MARK: View functionality
    func viewFunctionality(){
        usernametf.delegate = self
        passwordtf.delegate = self
        
        textField_cornerRadius(textField: usernametf)
        textField_cornerRadius(textField: passwordtf)
    }
    
    
    
    
    //MARK: Login function
    @IBAction func loginclicked(_ sender: Any) {
        
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbpath = url.appendingPathComponent("LoginSignup.plist")
        let dic = NSMutableDictionary(contentsOfFile: dbpath.path)
        
        if dic!.count > 0{
            if usernametf.text! != "" && passwordtf.text! != ""{
                
                if let a = dic!.value(forKey: "\(usernametf.text!)"){
                    
                    let array = a as! NSArray
                    //                    print("array = \(array)")
                    
                    let password = array[4]as! String
                    //                    print("password  = \(password)")
                    
                    if password == passwordtf.text!{
                        LoginViewController.uniqueUsername = "\(usernametf.text!)"
                        let tvc = TableViewController()
                        self.navigationController?.pushViewController(tvc, animated: true)
                    }else{
                         self.showAlert(title: "Alert", message: "wrong password.")
                    }
                    
                }else{
                    self.showAlert(title: "Alert", message: "wrong username.")
                }
                
            }else{
                self.showAlert(title: "Alert", message: "Username and password fields are mandatory.")
            }
        }
    }
}





extension LoginViewController:UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}
