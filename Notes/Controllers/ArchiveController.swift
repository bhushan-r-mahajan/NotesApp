//
//  ArchiveController.swift
//  Notes
//
//  Created by Gadgetzone on 16/07/21.
//

import UIKit

class ArchiveController: UIViewController {
    
    //MARK: - Variables
    
    let firebaseManager = FirebaseManager()
    var archivedNotes = [Notes]()
    var isArchive: Bool = true
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1))
        configureNavigationBar()
        configureCollectionView()
        fetchArchivedNotes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .clear
    }

    
    //MARK: - Configuration
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.168627451, alpha: 1))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Archived Notes"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left", withConfiguration:  UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: NotesCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    //MARK: - Handlers
    
    func fetchArchivedNotes() {
        firebaseManager.fetchArchivedNotes { archivedNotes in
            self.archivedNotes = archivedNotes
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Navigators
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ArchiveController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(archivedNotes.count)
        return archivedNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesCollectionViewCell.reuseIdentifier, for: indexPath) as! NotesCollectionViewCell
        cell.note = archivedNotes[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(100)
        return CGSize(width: (view.frame.width / 2) - 15, height: height)
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
        let note = archivedNotes[indexPath.row]
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Unarchive", style: .default, handler: { [weak self] (_) in
            self?.firebaseManager.updateArchiveorNot(note: note, isArchived: self!.isArchive)
            self?.fetchArchivedNotes()
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (_) in
            let note = self?.archivedNotes[indexPath.row]
            self?.firebaseManager.deleteNote(note: note!)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }))

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
}
