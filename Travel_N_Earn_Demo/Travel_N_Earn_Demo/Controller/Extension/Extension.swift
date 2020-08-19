//
//  Extension.swift
//  Travel_N_Earn_Demo
//
//  Created by Abhishek Suryawanshi on 14/06/20.
//  Copyright © 2020 Vinayak Balaji Tuptewar. All rights reserved.
//

import UIKit
import Foundation


extension UIViewController {
    //MARK: Alert function
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let click_action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(click_action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: TextView function
    func textView_cornerRadius(textView: UITextView) {
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = textView.frame.size.height/2
        textView.clipsToBounds = true
    }
    
    
    
    //MARK: TextField function
    func textField_cornerRadius(textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = textField.frame.size.height/2
        textField.clipsToBounds = true
    }
    
}
