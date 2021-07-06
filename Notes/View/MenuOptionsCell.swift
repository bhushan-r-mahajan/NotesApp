//
//  MenuOptionsCell.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit

class MenuOptionsCell: UITableViewCell {
    
    // Mark: - Properties
    
    let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()
    
    let descriptionLabel: UILabel = {
        let description = UILabel()
        description.textColor = .white
        description.font = UIFont.systemFont(ofSize: 16)
        description.text = "Labels"
        return description
    }()
    
    // Mark: - Init
    	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(iconImage)
        iconImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImage.anchor(left: leftAnchor, paddingLeft: 15, width: 30, height: 30)
        
        addSubview(descriptionLabel)
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.anchor(left: iconImage.rightAnchor, paddingLeft: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
