//
//  NotesCollectionViewCell.swift
//  Notes
//
//  Created by Gadgetzone on 06/07/21.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "NotesCollectionViewCell"
    
    var titleLabelField: UILabel = {
        var titleField = UILabel()
        titleField.font = UIFont.systemFont(ofSize: 20)
        titleField.textColor = .white
        titleField.clipsToBounds = true
        return titleField
    }()
    
    var noteLabelField: UILabel = {
        var noteField = UILabel()
        noteField.font = UIFont.systemFont(ofSize: 17)
        noteField.textColor = .white
        noteField.clipsToBounds = true
        return noteField
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabelField)
        contentView.addSubview(noteLabelField)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabelField.anchor(top: contentView.topAnchor, paddingTop: 20, left: contentView.leftAnchor, paddingLeft: 12, right: contentView.rightAnchor, paddingRight: 12)
        noteLabelField.anchor(top: titleLabelField.bottomAnchor, paddingTop: 10, left: contentView.leftAnchor, paddingLeft: 12, right: contentView.rightAnchor, paddingRight: 12)
        noteLabelField.lineBreakMode = .byWordWrapping
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //titleLabelField.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
