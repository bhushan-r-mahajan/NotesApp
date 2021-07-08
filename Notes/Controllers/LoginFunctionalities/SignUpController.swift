//
//  SignUpController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    let firstnameTextField = UITextField()
    let lastnameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let firstnameContainer = UIView()
    let lastnameContainer = UIView()
    let emailContainer = UIView()
    let passwordContainer = UIView()
    
    let logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.image = #imageLiteral(resourceName: "accountIcon")
        imgView.layer.cornerRadius = 100
        return imgView
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4588235294, blue: 0.8901960784, alpha: 1).withAlphaComponent(1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - ConfigureView
    
    func configureViewComponents() {
        view.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, paddingTop: 50, width: 200, height: 200)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        firstnameTextField.StyleTextField(placeholder: "Firstname", isSecureText: false)
        view.addSubview(firstnameContainer)
        firstnameContainer.anchor(top: logoImageView.bottomAnchor, paddingTop: 20, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        firstnameContainer.textContainerView(view: firstnameContainer, image: #imageLiteral(resourceName: "contactsIcon"), textField: firstnameTextField)
        
        lastnameTextField.StyleTextField(placeholder: "Lastname", isSecureText: false)
        view.addSubview(lastnameContainer)
        lastnameContainer.anchor(top: firstnameContainer.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        lastnameContainer.textContainerView(view: lastnameContainer, image: #imageLiteral(resourceName: "contactsIcon"), textField: lastnameTextField)
        
        emailTextField.StyleTextField(placeholder: "Email", isSecureText: false)
        view.addSubview(emailContainer)
        emailContainer.anchor(top: lastnameContainer.bottomAnchor, paddingTop: 24, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        emailContainer.textContainerView(view: emailContainer, image: #imageLiteral(resourceName: "emailIcon"), textField: emailTextField)
        
        passwordTextField.StyleTextField(placeholder: "Password", isSecureText: true)
        view.addSubview(passwordContainer)
        passwordContainer.anchor(top: emailContainer.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        passwordContainer.textContainerView(view: passwordContainer, image: #imageLiteral(resourceName: "passwordIcon"), textField: passwordTextField)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: passwordContainer.bottomAnchor, paddingTop: 30 ,left: view.leftAnchor, paddingLeft: 70, right: view.rightAnchor, paddingRight: 70, height: 50)
    }
    
    // MARK: - Handlers
    
    @objc func signUpButtonTapped() {
        
        let firstname = firstnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = lastnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        Auth.auth().createUser(withEmail: email , password: password) { (result, problem) in
            let uid = result?.user.uid
            if let problem = problem {
                print("Error Creating Account !", problem.localizedDescription)
                self.present(Checker.showAlert(title: "Sign Up Failed", message: "\(problem.localizedDescription) . Try again"), animated: true, completion: nil)
            } else {
                Firestore.firestore().collection("users").addDocument(data: ["firstname":firstname, "lastname":lastname, "uid":uid!]) { (error) in
                    if error != nil {
                        print("Error Adding Data To Firsbase!", error!.localizedDescription)
                    }
                }
                print("signup successful")
                self.view.window?.makeKeyAndVisible()
                let homeScreen = ContainerController()
                self.view.window?.rootViewController = homeScreen
            }
        }
    }
}
