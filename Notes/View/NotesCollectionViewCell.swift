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
    
    var note: Notes? {
        didSet {
            configure()
        }
    }
    
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
        noteField.numberOfLines = 0
        return noteField
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabelField)
        contentView.addSubview(noteLabelField)
        
        backgroundColor = .clear
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.borderWidth = 0.7
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabelField.anchor(top: contentView.topAnchor, paddingTop: 10, left: contentView.leftAnchor, paddingLeft: 10, right: contentView.rightAnchor, paddingRight: 10)
        titleLabelField.numberOfLines = 0
        titleLabelField.lineBreakMode = .byWordWrapping
        
        noteLabelField.anchor(top: titleLabelField.bottomAnchor, paddingTop: 20, left: contentView.leftAnchor, paddingLeft: 10)
        noteLabelField.numberOfLines = 0
        noteLabelField.lineBreakMode = .byWordWrapping
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //titleLabelField.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let note = note else { return }
        titleLabelField.text = note.noteTitle
        noteLabelField.text = note.noteDescription
    }
}
