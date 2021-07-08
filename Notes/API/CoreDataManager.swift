//
//  CoreDataFunctions.swift
//  Notes
//
//  Created by Gadgetzone on 07/07/21.
//

import UIKit
import CoreData

struct CoreDataManager {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var models = [Notes]()
    
    static func getAllNotes(completion: ([Notes]) -> Void) {
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        do {
            let model = try context.fetch(request)
            completion(model)
        } catch {
            print("Error fetching items")
        }
    }
    
    static func createNote(titleContent: String, noteContent: String) {
        let newItem = Notes(context: context)
        newItem.title = titleContent
        newItem.note = noteContent
        print("\(titleContent)")
        
        do {
            try context.save()
            getAllNotes { notes in
                self.models = notes
            }
        } catch {
            print("Error creating data")
        }
    }
    
    static func updateNotes(item: Notes, newTitle: String, newNote: String) {
        item.title = newTitle
        item.note = newNote
        do {
            try context.save()
            getAllNotes { notes in
                self.models = notes
            }
        } catch {
            print("Error editing data")
        }
    }
    
    static func deleteNotes(item: Notes) {
        context.delete(item)
        print("Delete Called")
        do {
            try context.save()
            getAllNotes { notes in
                self.models = notes
            }
        } catch {
            print("Error deleting data")
        }
    }
}