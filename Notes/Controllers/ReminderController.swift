//
//  ReminderController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit

class RemainderController: UIViewController {
    
    // MARK: - Properties
    
    let databaseManager = DatabaseManager()
    
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
                                          attributes: [NSAttributedString.Key.foregroundColor:            UIColor.white])
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .white
        textField.backgroundColor = .clear
        return textField
    }()
    
    var datePicker: UIDatePicker = {
        var picker = UIDatePicker()
        return picker
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureReminderController()
    }
    
    // MARK: - Handlers
    
    func configureReminderController() {
        view.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.168627451, alpha: 1))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Add Reminder"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "externaldrive.badge.plus", withConfiguration:  UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left", withConfiguration:  UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        
        view.addSubview(titleField)
        titleField.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 50)
        
        view.addSubview(descriptionField)
        descriptionField.anchor(top: titleField.bottomAnchor, paddingTop: 20, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 70)
        
        view.addSubview(datePicker)
        //datePicker.anchor(top: descriptionField.bottomAnchor, paddingTop: 100)
        //datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        datePicker.center = view.center
    }
    
    func showReminder(title: String, body: String, date: NSDate) {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] success, error in
                if success {
                    // schedule notifications
                    
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = body
                    content.sound = .default
                    let targetdate = date
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetdate as Date), repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { error in
                        if error != nil {
                            print("Something is Wrong")
                        }
                    }
                    
                } else if let error = error {
                    print("Access denied \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc func saveButtonClicked() {
        guard let title = titleField.text else { return }
        guard let description = descriptionField.text else { return }
        let date = datePicker.date
        let note = Notes(noteTitle: title, noteDescription: description, loggedInUserID: "", documentID: "", date: date as NSDate, isArchived: false)
        databaseManager.saveData(note: note) { error in
            if error != nil {
                print("Error Saving data \(error!.localizedDescription)")
            }
        }
        self.showReminder(title: title, body: description, date: date as NSDate)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
