//
//  Users.swift
//  Notes
//
//  Created by Gadgetzone on 17/07/21.
//

import UIKit
import Firebase

class Users {
    
    var firstname: String
    var lastname: String
    var email: String
    var profilePhoto: UIImage?
    var loggedInUserID: String?
    
    
    var userDictionary: [String: Any] {
        return ["firstname":firstname, "lastname":lastname, "email":email, "loggedInUserID":loggedInUserID!, "profilePhoto":""]
    }
    
    init(firstname: String, lastname: String, email: String, loggedInUserID: String, profilePhoto: UIImage) {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.profilePhoto = profilePhoto
        self.loggedInUserID = loggedInUserID
    }
    
    convenience init(dictionary: [String: Any]) {
        let firstname = dictionary["firstname"] as! String? ?? ""
        let lastname = dictionary["lastname"] as! String? ?? ""
        let email = dictionary["email"] as! String? ?? ""
        let loggedInUserID = dictionary["uid"] as! String
        let profilePhoto = dictionary["profilePhoto"] as? UIImage ?? #imageLiteral(resourceName: "profileIcon")
        self.init(firstname: firstname, lastname: lastname, email: email, loggedInUserID: loggedInUserID, profilePhoto: profilePhoto)
    }
}

