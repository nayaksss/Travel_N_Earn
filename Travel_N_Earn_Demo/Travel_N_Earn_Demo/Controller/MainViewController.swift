//
//  MainViewController.swift
//  Travel_N_Earn_Demo
//
//  Created by Vinayak Balaji Tuptewar on 30/05/20.
//  Copyright © 2020 Vinayak Balaji Tuptewar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginViewController.uniqueUsername = ""
    }
    
    
    
    @IBAction func loginclicked(_ sender: Any){
        let loginvc = LoginViewController()
        self.navigationController?.pushViewController(loginvc, animated: true)
        
    }
    
    
    
    @IBAction func signupclicked(_ sender: Any){
        let signupvc = SignupViewController()
        self.navigationController?.pushViewController(signupvc, animated: true)
        
    }
    
}
