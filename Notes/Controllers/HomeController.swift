//
//  HomeController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit
import Firebase
import UserNotifications

class HomeController: UIViewController {
    
    // MARK:- Firebase variables
    
    var firebaseManager = FirebaseManager()
    var notesArray = [Notes]()
    var note: Notes!
    static var cellSelected: Int?
    var countOfNotesInDB = 0
    
    // MARK: - Search Variables
    
    let searchController = UISearchController()
    var isSearching = false
    var searchedNotes = [Notes]()
    
    // MARK:- Variables
    
    let databaseManager = DatabaseManager()
    static var selectedCell: IndexPath?
    let models = [NotesCoreData]()
    private var collectionReferance: CollectionReference!
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: HomeControllerDelegate?
    var isArchive: Bool = false
    var archivedNotes = [Notes]()
    
    var isListView: Bool = false
    var height: CGFloat = 0
    var width: CGFloat = 0
    
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
        label.text = "Notes you add appear here"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let gridButton: UIImage! = {
        let button = UIImage(systemName: "rectangle.grid.2x2.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return button
    }()
    
    let listButton: UIImage! = {
        let button = UIImage(systemName: "list.triangle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return button
    }()
    
    let archiveButton: UIImage! = {
        let button = UIImage(systemName: "archivebox")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return button
    }()
    
    // MARK:- Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1))
        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        toggleHomeControllerLabel()
        configureAddButton()
        fetchNotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchNotes()
        toggleHomeControllerLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNotes()
        toggleHomeControllerLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .clear
        toggleHomeControllerLabel()
    }

    // MARK:- Handlers
    
    func fetchNotes() {
        firebaseManager.fetchNotes { [weak self] notes in
            self?.notesArray = notes
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func configureAddButton() {
        view.addSubview(addButton)
        addButton.anchor(right: view.rightAnchor, paddingRight: 20, bottom: view.bottomAnchor, paddingBottom: 20, width: 70, height: 70)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func toggleHomeControllerLabel() {
        view.addSubview(noNotesLabel)
        noNotesLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        noNotesLabel.center = view.center

        if notesArray.count == 0 {
            noNotesLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            noNotesLabel.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.168627451, alpha: 1))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Notes"
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(menuButtonClicked))
        
        navigationItem.rightBarButtonItems = [ UIBarButtonItem(image: listButton, style: .plain, target: self, action: #selector(toggleView)), UIBarButtonItem(image: archiveButton, style: .plain, target: self, action: #selector(archiveController))]
    }
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Notes"
        
    }
    
    func viewToogle(image: UIImage) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.toggleView))
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: NotesCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    // MARK: - Actions
    
    @objc func toggleView() {
        if isListView {
            viewToogle(image: listButton)
        } else {
            viewToogle(image: gridButton)
        }
        isListView = !isListView
    }
    
    @objc func addButtonTapped() {
        let addNotes = AddNotesController()
        navigationController?.pushViewController(addNotes, animated: true)
    }
    
    @objc func menuButtonClicked() {
        print("menu tapped")
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func archiveController() {
        let archiveController = ArchiveController()
        navigationController?.pushViewController(archiveController, animated: true)
    }
}

// MARK: - Extension for CollectionView

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchBarDelegate {
    
    // functions for SearchController delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchedText = searchController.searchBar.text!
        if !searchedText.isEmpty {
            isSearching = true
            searchedNotes.removeAll()
            for note in notesArray {
                if note.noteTitle.lowercased().contains(searchedText.lowercased()) {
                    searchedNotes.append(note)
                }
            }
        } else {
            isSearching = false
            searchedNotes.removeAll()
            searchedNotes = notesArray
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    // functions for CollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? searchedNotes.count : notesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesCollectionViewCell.reuseIdentifier, for: indexPath) as! NotesCollectionViewCell
        cell.note = isSearching ? searchedNotes[indexPath.row] : notesArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        height = CGFloat(100)
        return isListView ? CGSize(width: (view.frame.width) - 40, height: height) : CGSize(width: (view.frame.width / 2) - 15, height: height)
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
        
        HomeController.selectedCell = indexPath
        collectionView.deselectItem(at: indexPath, animated: true)
        print("selected")
        let note = notesArray[indexPath.row]
        //let item = models[indexPath.row]

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            let editController = EditNotesController()
            editController.delegate = self
            editController.titleField.text = self.notesArray[indexPath.row].noteTitle
            editController.descriptionField.text = self.notesArray[indexPath.row].noteDescription
            editController.selectedCell = self.notesArray[indexPath.row]
            self.navigationController?.pushViewController(editController, animated: true)
        }))

        sheet.addAction(UIAlertAction(title: "Archive", style: .default, handler: { [weak self] (_) in
            self?.firebaseManager.updateArchiveorNot(note: note, isArchived: self!.isArchive)
            self?.fetchNotes()
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (_) in
            let note = self?.notesArray[indexPath.row]
            self?.firebaseManager.deleteNote(note: note!)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.toggleHomeControllerLabel()
            }
        }))

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        firebaseManager.getCount { [weak self] countFromDB in
            self?.countOfNotesInDB = countFromDB
        }
        let lastNote = notesArray.count - 2
        if (notesArray.count < countOfNotesInDB && indexPath.row == lastNote) {
                firebaseManager.paginate { notes in
                    self.notesArray.append(contentsOf: notes)
                }
            }
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
    }
}

// MARK: - Extension for Update Data in CoreData

extension HomeController: editNoteDelegate {
    func update(title: String, description: String) {
        let item = models[HomeController.selectedCell!.row]
        item.title = title
        item.note = description
        CoreDataManager.updateNotes(item: item, newTitle: title, newNote: description)
    }
}

