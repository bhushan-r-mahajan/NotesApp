//
//  LoginController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    let logoImage: UIImageView = {
        let logo = UIImageView()
        logo.clipsToBounds = true
        return logo
    }()
    
    let emailTextField: UITextField = {
        let emailField = UITextField()
        return emailField
    }()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Handlers
    
    func configureLoginController() {
        
    }
    
}
