//
//  HomeController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit

class HomeController: UIViewController {

    // MARK:- Properties
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: HomeControllerDelegate?
    var models = [Notes]()
    let searchController = UISearchController()
    
    var addButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5960784314, blue: 0.1411764706, alpha: 1)
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "addIcon"), for: .normal)
        button.layer.cornerRadius = 35
        return button
    }()
    
    var noNotesLabel: UILabel = {
        var label = UILabel()
        label.text = "Notes you add will appear here"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK:- Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllNotes()
        
        view.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1))
        
        configureNavigationBar()
        configureCollectionView()
        
        //collectionView.addSubview(noNotesLabel)
        //noNotesLabel.center = collectionView.center
        //toggleHomeControllerLabel()
        
        configureAddButton()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .clear
    }

    // MARK:- Handlers
    
    @objc func addButtonTapped() {
        let addNotes = AddNotesController()
        navigationController?.pushViewController(addNotes, animated: true)
    }
    
    @objc func menuButtonClicked() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureAddButton() {
        view.addSubview(addButton)
        addButton.anchor(right: view.rightAnchor, paddingRight: 20, bottom: view.bottomAnchor, paddingBottom: 20, width: 70, height: 70)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func toggleHomeControllerLabel() {
        if models.count == 0 {
            noNotesLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            noNotesLabel.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.168627451, alpha: 1))
        navigationController?.navigationBar.barStyle = .default
        navigationItem.searchController = searchController
        
        navigationItem.title = "Notes"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuButtonClicked))
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: NotesCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    // MARK: - CoreData
    
    func getAllNotes() {
        do {
            models = try context.fetch(Notes.fetchRequest())
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            print("Error fetching items")
        }
    }
    
    func createNote(titleContent: String, noteContent: String) {
        print("method called")
        let newItem = Notes(context: context)
        newItem.title = titleContent
        newItem.note = noteContent
        print("\(titleContent)")
        
        do {
            try context.save()
            getAllNotes()
        } catch {
            print("Error creating data")
        }
    }
    
    func updateNotes(item: Notes, newTitle: String, newNote: String) {
        item.title = newTitle
        item.note = newNote
        do {
            try context.save()
            getAllNotes()
        } catch {
            print("Error editing data")
        }
    }
    
    func deleteNotes(item: Notes) {
        context.delete(item)
        
        do {
            try context.save()
            getAllNotes()
        } catch {
            print("Error deleting data")
        }
    }
}

    // MARK: - Extensions

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesCollectionViewCell.reuseIdentifier, for: indexPath) as! NotesCollectionViewCell
        cell.backgroundColor = .clear
        cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.layer.borderWidth = 0.7
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.titleLabelField.text = model.title
        cell.noteLabelField.text = model.note
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 12) / 2.1
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("selected")
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] (_) in
            
            let editNotes = EditNotesController()
            //self?.updateNotes(item: item, newTitle: tit, newNote: <#T##String#>)
            self?.navigationController?.pushViewController(editNotes, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (_) in
            self?.deleteNotes(item: item)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
}
