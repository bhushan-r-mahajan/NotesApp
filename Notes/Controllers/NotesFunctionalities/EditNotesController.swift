//
//  EditNotesController.swift
//  Notes
//
//  Created by Gadgetzone on 06/07/21.
//

import UIKit

class EditNotesController: UIViewController {
    
    // MARK: - Properties
    
    let models = [Notes]()
    var titleField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Enter Title"
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.becomeFirstResponder()
        return textField
    }()
    var noteField: UITextView = {
        var textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .white
        textView.backgroundColor = .clear
        return textView
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1))
        
        view.addSubview(titleField)
        titleField.anchor(top: view.topAnchor, paddingTop: 100, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 50)
        
        view.addSubview(noteField)
        noteField.anchor(top: titleField.bottomAnchor, paddingTop: 20, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, bottom: view.bottomAnchor, paddingBottom: 30)
        
        configureNavigationBar()
    }
    
    // MARK: - Handlers
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Edit Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "saveIcon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    @objc func saveButtonClicked() {
        let vc = HomeController()
        vc.createNote(titleContent: titleField.text ?? "", noteContent: noteField.text ?? "")
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
