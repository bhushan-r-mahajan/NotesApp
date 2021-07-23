//
//  EditNotesController.swift
//  Notes
//
//  Created by Gadgetzone on 06/07/21.
//

import UIKit

protocol editNoteDelegate: AnyObject {
    func update(title: String, description: String)
}

class EditNotesController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: editNoteDelegate?
    let databaseManager = DatabaseManager()
    var notes: Notes!
    var notesArray = [Notes]()
    var firebaseManager = FirebaseManager()
    var selectedCell: Notes?

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
    
    init() {
        print("Edit view controller")
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureEditController()
    }
    
    deinit {
        print("deinitialzed edit controller")
    }
    
    // MARK: - Handlers
    
    func configureEditController() {
        view.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1))
        
        view.addSubview(titleField)
        titleField.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 50)
        
        view.addSubview(descriptionField)
        descriptionField.anchor(top: titleField.bottomAnchor, paddingTop: 20, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 70)
        
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.168627451, alpha: 1))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Edit Notes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "externaldrive.badge.plus", withConfiguration:  UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(saveButtonClicked))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left", withConfiguration:  UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonClicked() {
        //delegate?.update(title: titleField.text ?? "", description: descriptionField.text ?? "")
        self.databaseManager.updateData(note: self.selectedCell!,
                                        newTitle: self.titleField.text!,
                                        newDescription: self.descriptionField.text!)
        self.navigationController?.popViewController(animated: true)
    }
}
