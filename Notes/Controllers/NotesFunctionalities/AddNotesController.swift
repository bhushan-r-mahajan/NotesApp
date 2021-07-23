//
//  AddNotesController.swift
//  Notes
//
//  Created by Gadgetzone on 06/07/21.
//

import UIKit
import Firebase

class AddNotesController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    var notes: Notes!
    let databaseManager = DatabaseManager()
    
    let vc = ContainerController()
    let home = HomeController()
    var titleField: UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Title",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.becomeFirstResponder()
        return textField
    }()
    var descriptionField: UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Note",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .white
        textField.backgroundColor = .clear
        return textField
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureAddController()
        self.configureNavigationBar()
    }
    
    // MARK: - Handlers
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.168627451, alpha: 1))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black

        navigationItem.title = "Add Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "externaldrive.badge.plus", withConfiguration:  UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(saveButtonClicked))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left", withConfiguration:  UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    func configureAddController() {
        
        view.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1))
        
        view.addSubview(titleField)
        titleField.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 50)
        
        view.addSubview(descriptionField)
        descriptionField.anchor(top: titleField.bottomAnchor, paddingTop: 20, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 70)
        
    }
    
    @objc func saveButtonClicked() {
        guard let title = titleField.text else { return }
        guard let description = descriptionField.text else { return }
        let note = Notes(noteTitle: title, noteDescription: description, loggedInUserID: "", documentID: "", date: NSDate.now as NSDate, isArchived: false)
        databaseManager.saveData(note: note) { error in
            if error != nil {
                print("Error Saving data \(error!.localizedDescription)")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

