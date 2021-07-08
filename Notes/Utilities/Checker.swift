//
//  Checker.swift
//  Notes
//
//  Created by Gadgetzone on 07/07/21.
//

import UIKit

class Checker {
    
    static func isemailValid(_ email : String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
        return emailTest.evaluate(with: email)
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func showAlert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let show = UIAlertAction(title: "Ok", style: .cancel) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(show)
        return alert
    }
}
