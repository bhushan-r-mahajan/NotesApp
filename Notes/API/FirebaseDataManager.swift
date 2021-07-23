//
//  FirebaseDataManager.swift
//  Notes
//
//  Created by Gadgetzone on 10/07/21.
//

import UIKit
import Firebase

class FirebaseManager {

    var lastSnapshot: DocumentSnapshot!
    let userId = Auth.auth().currentUser?.uid
    var query: Query!
    
    func paginate(completed: @escaping ([Notes]) -> ()) {
        query.start(afterDocument: self.lastSnapshot).limit(to: 5).addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            var notes: [Notes] = []

            querySnapshot!.documents.forEach({ (document) in
                let note = Notes(dictionary: document.data())
                note.documentID = document.documentID
                notes.append(note)
            })
            completed(notes)
        }
    }
    
    func getCount(completed: @escaping (Int) -> ()) {
        let db = Firestore.firestore()
        db.collection("Notes").document(userId!).collection("User Notes").getDocuments { querySnapshot, error in
            if let error = error {
                print("error getting count \(error.localizedDescription)")
            } else {
                var count = 0
                for _ in querySnapshot!.documents {
                    count += 1
                }
                completed(count)
            }
        }
    }
    
    func fetchNotes(completed: @escaping ([Notes]) -> ()) {
        let db = Firestore.firestore()
        query = db.collection("Notes").document(userId!).collection("User Notes").whereField("archived", isEqualTo: false).limit(to: 15).order(by: "date", descending: true)
        query.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            var notes: [Notes] = []
            querySnapshot!.documents.forEach({ (document) in
                let note = Notes(dictionary: document.data())
                note.documentID = document.documentID
                notes.append(note)
            })
            self.lastSnapshot = querySnapshot?.documents.last
            completed(notes)
        }
    }
    
    func fetchArchivedNotes(completed: @escaping ([Notes]) -> ()) {
        let db = Firestore.firestore()
        db.collection("Notes").document(userId!).collection("User Notes").whereField("archived", isEqualTo: true).limit(to: 15).order(by: "date", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard error == nil else {
                    return
                }
                var archivedNotes: [Notes] = []
                querySnapshot!.documents.forEach({ (document) in
                    let note = Notes(dictionary: document.data())
                    note.documentID = document.documentID
                    archivedNotes.append(note)
                })
//                self.lastSnapshot = querySnapshot?.documents.last
                completed(archivedNotes)
        }
                
    }
    
    func saveData(note: Notes, completion: @escaping (Error?) -> ()) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error user is not valid user")
            return 
        }
        note.loggedInUserID = userId
        let noteToSave: [String: Any] = note.dictionary
        var ref: DocumentReference? = nil
        ref = db.collection("Notes").document(userId).collection("User Notes").addDocument(data: noteToSave) { error in
                if error != nil {
                    print("Error Adding document \(String(describing: error?.localizedDescription))")
                    completion(error)
                }
            note.documentID = ref!.documentID
            print("Successfully added document \(String(describing: note.documentID))")
        }
    }
    
    func updateNote(note: Notes, title: String, description: String) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error user is not valid user")
            return
        }
        db.collection("Notes").document(userId).collection("User Notes").document(note.documentID!).updateData(["title": title, "description": description]) { error in
            if let error = error {
                print("Update failed \(error.localizedDescription)")
            }
        }
    }
    
    func updateArchiveorNot(note: Notes, isArchived: Bool) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error user is not valid user")
            return
        }
        let noteRef = db.collection("Notes").document(userId).collection("User Notes").document(note.documentID!)
        if note.isArchived == false {
            noteRef.updateData([ "archived": true ]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated")
                }
            }
        } else if note.isArchived == true {
            noteRef.updateData([ "archived": false ]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
    
    func deleteNote(note: Notes) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error user is not valid user")
            return
        }
        db.collection("Notes").document(userId).collection("User Notes").document(note.documentID!).delete { error in
            if let error = error {
                print("Error deleting document!! \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUserData(completed: @escaping ([Users]) -> ()) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error user is not valid user")
            return
        }
        db.collection("users").whereField("uid", isEqualTo: userId).getDocuments { querySnapshot, error in
                var users: [Users] = []
                querySnapshot!.documents.forEach({ (document) in
                    let user = Users(dictionary: document.data())
                    users.append(user)
                })
                completed(users)
        }
    }
}
