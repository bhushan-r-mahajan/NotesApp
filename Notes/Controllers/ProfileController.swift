//
//  ProfileController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit

class ProfileController: UIViewController {
    
    //MARK: - Variables
    
    var userArray = [Users]()
    var firebaseManager = FirebaseManager()
    
    // MARK: - Properties
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person.fill.badge.plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        return image
    }()
    
    let firstnameLabelField = UILabel()
    let firstnameContainer = UIView()
    let lastnameLabelField = UILabel()
    let lastnameContainer = UIView()
    let emailLabelField = UILabel()
    let emailContainer = UIView()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        fetchUsers()
    }
    
    //MARK: - Configurations
    
    func configureViewComponents() {
        view.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
    
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.168627451, alpha: 1))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left", withConfiguration:  UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        
        view.addSubview(profileImage)
        profileImage.anchor(top: view.topAnchor, paddingTop: 150, width: 200, height: 200)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        firstnameLabelField.StyleLabelField()
        view.addSubview(firstnameContainer)
        firstnameContainer.anchor(top: profileImage.bottomAnchor, paddingTop: 40, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        firstnameContainer.labelContainerView(view: firstnameContainer, image: #imageLiteral(resourceName: "profileIcon"), labelField: firstnameLabelField)
        
        lastnameLabelField.StyleLabelField()
        view.addSubview(lastnameContainer)
        lastnameContainer.anchor(top: firstnameContainer.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        lastnameContainer.labelContainerView(view: lastnameContainer, image: #imageLiteral(resourceName: "profileIcon"), labelField: lastnameLabelField)
        
        emailLabelField.StyleLabelField()
        view.addSubview(emailContainer)
        emailContainer.anchor(top: lastnameContainer.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
        emailContainer.labelContainerView(view: emailContainer, image: #imageLiteral(resourceName: "emailIcon"), labelField: emailLabelField)
    }
    
    // MARK: - Handlers
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API Methods
    
    func fetchUsers() {
        firebaseManager.fetchUserData { [weak self] user in
            self?.userArray = user
            self?.firstnameLabelField.text = self?.userArray[0].firstname
            self?.lastnameLabelField.text = self?.userArray[0].lastname
            self?.emailLabelField.text = self?.userArray[0].email
        }
    }
}
