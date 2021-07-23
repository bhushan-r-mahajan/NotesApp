//
//  SignUpController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    //weak var delegate: authenticationDelegate?
    
    let firstnameTextField = UITextField()
    let lastnameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let firstnameContainer = UIView()
    let lastnameContainer = UIView()
    let emailContainer = UIView()
    let passwordContainer = UIView()
    var selectedImage: UIImage?
    
    let profileImage: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setBackgroundImage(UIImage(systemName: "person.fill.badge.plus")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(profileImageSelectorTapped), for: .touchUpInside)
        //button.layer.cornerRadius = 100
        return button
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
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have account ?", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string:"Login", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(alreadyHaveAccountButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        dismiss(animated: true, completion: nil)
//    }
    
    // MARK: - ConfigureView
    
    func configureViewComponents() {
        view.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    
        view.addSubview(profileImage)
        profileImage.anchor(top: view.topAnchor, paddingTop: 70, width: 200, height: 200)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        firstnameTextField.StyleTextField(placeholder: "Firstname", isSecureText: false)
        view.addSubview(firstnameContainer)
        firstnameContainer.anchor(top: profileImage.bottomAnchor, paddingTop: 40, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
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
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, paddingLeft: 70, right: view.rightAnchor, paddingRight: 70, bottom: view.bottomAnchor, paddingBottom: 40, height: 50)
    }
    
    // MARK: - Handlers
    
    @objc func profileImageSelectorTapped() {
        print("imageview tapped")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func alreadyHaveAccountButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func signUpButtonTapped() {
        
        let firstname = firstnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = lastnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let image = self.selectedImage else {
            return
        }
        guard let imagedata = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        Auth.auth().createUser(withEmail: email , password: password) { [weak self] (result, problem) in
            let uid = result?.user.uid
            if let problem = problem {
                print("Error Creating Account !", problem.localizedDescription)
                self?.present(Checker.showAlert(title: "Sign Up Failed", message: "\(problem.localizedDescription) . Try again"), animated: true, completion: nil)
                return
            }
            print("===========================", uid!)
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference(withPath: "profileImage/\(fileName)")
//                let storageProfileRef = storageRef.child("Users").child(uid!)
//                let metadata = StorageMetadata()
//                metadata.contentType = "image/jpg"
//                storageProfileRef.putData(imagedata, metadata: metadata) { storageMetaData, error in
//                    if let error = error {
//                        print("Error saving profile photo \(error.localizedDescription)")
//                    }
//                }
                storageRef.putData(imagedata, metadata: nil) { storageMetaData, error in
                    if let e = error {
                        print("Error putting image in storage \(e.localizedDescription)")
                        return
                    }
                }
                print("****************")
                storageRef.downloadURL { url, error in
//                    if let e = error {
//                        //print(e.localizedDescription)
//                        return
//                    }
                    print("11111111")
                    guard let imageURl = url?.absoluteString else { return }
                    print("\(String(describing: imageURl))")
                }
            
            Firestore.firestore().collection("users").addDocument(data: ["firstname": firstname, "lastname": lastname, "uid": uid!, "profilePhoto": "", "email": email]) { (error) in
            if error != nil {
                print("Error Adding Data To Firsbase!", error!.localizedDescription)
            }
            }
            print("signup successful")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImage.setImage(image, for: .normal)
            selectedImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
