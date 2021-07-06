//
//  MenuOptions.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    case Profile
    case Reminders
    case Logout
    
    var description: String {
        switch self {
        case .Profile: return "Profile"
        case .Reminders: return "Reminders"
        case .Logout: return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile: return UIImage(named: "profileIcon") ?? UIImage()
        case .Reminders: return UIImage(named: "reminderIcon") ?? UIImage()
        case .Logout: return UIImage(named: "logoutIcon") ?? UIImage()
        }
    }
}
