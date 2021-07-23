//
//  Notes.swift
//  Notes
//
//  Created by Gadgetzone on 19/07/21.
//

import UIKit

class Notes {
    
    var noteTitle: String
    var noteDescription: String
    var loggedInUserID: String?
    var documentID: String?
    var date: NSDate?
    var isArchived: Bool?
    
    var dictionary: [String: Any] {
        return ["title": noteTitle, "description": noteDescription, "date": date ?? NSDate.now, "archived": isArchived!]
    }
    
    init(noteTitle: String, noteDescription: String, loggedInUserID: String, documentID: String, date: NSDate, isArchived: Bool) {
        self.noteTitle = noteTitle
        self.noteDescription = noteDescription
        self.loggedInUserID = loggedInUserID
        self.documentID = documentID
        self.date = date
        self.isArchived = isArchived
        
    }
    
    convenience init() {
        self.init(noteTitle: "", noteDescription: "", loggedInUserID: "", documentID: "", date: NSDate.now as NSDate, isArchived: false)
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let loggedInUserID = dictionary["loggedInUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        let date = dictionary["date"] as? NSDate ?? NSDate.now as NSDate
        let isArchived = dictionary["archived"] as? Bool ?? false
        self.init(noteTitle: title, noteDescription: description, loggedInUserID: loggedInUserID, documentID: documentID, date: date as NSDate, isArchived: isArchived)
    }
}
