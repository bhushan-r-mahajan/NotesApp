//
//  Notes+CoreDataProperties.swift
//  Notes
//
//  Created by Gadgetzone on 06/07/21.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var title: String?
    @NSManaged public var note: String?

}

extension Notes : Identifiable {

}
