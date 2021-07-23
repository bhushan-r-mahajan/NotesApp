//
//  DatabaseManager.swift
//  Notes
//
//  Created by Gadgetzone on 10/07/21.
//

import UIKit
import Firebase
import CoreData

class DatabaseManager {
    
    let coreData = CoreDataManager()
    let firebase = FirebaseManager()
    
    func saveData(note: Notes, completion: @escaping (Error?) -> ()) {
        firebase.saveData(note: note) { error in
            if error != nil {
                completion(error)
            }
        }
    }
    
    func updateData(note: Notes, newTitle: String, newDescription: String) {
        firebase.updateNote(note: note, title: newTitle, description: newDescription)
    }
    
    func deleteData(note: Notes) {
        firebase.deleteNote(note: note)
    }
}
