//
//  LoginController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit
import Firebase

//protocol authenticationDelegate: class {
//    func showHomeController()
//}

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    //weak var delegate: authenticationDelegate?
    
    let logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.image = #imageLiteral(resourceName: "NotesLogo")
        return imgView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4588235294, blue: 0.8901960784, alpha: 1).withAlphaComponent(1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password ?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have account ?", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string:"Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let emailContainer = UIView()
    let passwordContainer = UIView()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }
    
    // MARK: - ConfigureView
    
    func configureViewComponents() {
        view.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, paddingTop: 60, left: view.leftAnchor, paddingLeft: 50, right: view.rightAnchor, paddingRight: 50, height: 200)
        
        emailTextField.StyleTextField(placeholder: "Email", isSecureText: false)
        view.addSubview(emailContainer)
        emailContainer.anchor(top: logoImageView.bottomAnchor, paddingTop: 24, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        emailContainer.textContainerView(view: emailContainer, image: #imageLiteral(resourceName: "emailIcon"), textField: emailTextField)
        
        passwordTextField.StyleTextField(placeholder: "Password", isSecureText: true)
        view.addSubview(passwordContainer)
        passwordContainer.anchor(top: emailContainer.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        passwordContainer.textContainerView(view: passwordContainer, image: #imageLiteral(resourceName: "passwordIcon"), textField: passwordTextField)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: passwordContainer.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 60, right: view.rightAnchor, paddingRight: 60, height: 50)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: loginButton.bottomAnchor, paddingTop: 40, left: view.leftAnchor, paddingLeft: 60, right: view.rightAnchor, paddingRight: 60, height: 50)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(left: view.leftAnchor, paddingLeft: 70, right: view.rightAnchor, paddingRight: 70, bottom: view.bottomAnchor, paddingBottom: 40, height: 50)
    }
    
    // MARK: - Handlers
    
    @objc func loginButtonTapped() {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Checker.isemailValid(email) == false {
            print("Invalid Email")
            present(Checker.showAlert(title: "Invalid Email", message: "The Email you entered doesn't look right ! Try again !"), animated: true, completion: nil)
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Checker.isPasswordValid(password) == false {
            print("Invalid Password")
            present(Checker.showAlert(title: "Invalid Password", message: "The Password you entered doesn't look right ! Try again !"), animated: true, completion: nil)
        }
            
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                print("Error", error.localizedDescription)
                self?.present(Checker.showAlert(title: "Login Failed", message: "\(error.localizedDescription)"), animated: true, completion: nil)
            } else {
                print("Login Successful")
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func signUpButtonTapped() {
        let signUp = SignUpController()
        //signUp.delegate = delegate
        print("Signup button taopped!!!!")
        navigationController?.pushViewController(signUp, animated: true)
    }
    
    @objc func forgotPasswordButtonTapped() {
        
    }
}
