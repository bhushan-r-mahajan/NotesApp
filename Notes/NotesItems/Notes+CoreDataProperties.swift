//
//  Notes+CoreDataProperties.swift
//  Notes
//
//  Created by Gadgetzone on 06/07/21.
//
//

import Foundation
import CoreData

extension NotesCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesCoreData> {
        return NSFetchRequest<NotesCoreData>(entityName: "NotesCoreData")
    }

    @NSManaged public var title: String?
    @NSManaged public var note: String?

}

extension Notes : Identifiable {

}
