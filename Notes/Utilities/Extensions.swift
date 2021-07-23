//
//  Extensions.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit
import Firebase

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0, left: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = 0, right: NSLayoutXAxisAnchor? = nil, paddingRight: CGFloat? = 0, bottom: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let right = right {
            if let paddingRight = paddingRight{
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func textContainerView(view: UIView, image: UIImage, textField: UITextField) {
        
        view.backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 1
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(textField)
        textField.anchor(left: imageView.leftAnchor, paddingLeft: 30, right: view.rightAnchor, paddingRight: 8)
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 1, alpha: 1)
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, paddingLeft: 8, right: view.rightAnchor, paddingRight: 0, bottom: view.bottomAnchor, paddingBottom: 0, height: 1)
    }
    
    func labelContainerView(view: UIView, image: UIImage, labelField: UILabel) {
        
        view.backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 1
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(labelField)
        labelField.anchor(left: imageView.leftAnchor, paddingLeft: 30, right: view.rightAnchor, paddingRight: 8)
        labelField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 1, alpha: 1)
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, paddingLeft: 8, right: view.rightAnchor, paddingRight: 0, bottom: view.bottomAnchor, paddingBottom: 0, height: 1)
    }
}

extension UITextField {
    
    func StyleTextField(placeholder: String, isSecureText: Bool) {
        self.borderStyle = .none
        self.font = UIFont.systemFont(ofSize: 19)
        self.textColor = .white
        self.isSecureTextEntry = isSecureText
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}

extension UILabel {
    
    func StyleLabelField() {
        self.font = UIFont.systemFont(ofSize: 19)
        self.textColor = .white
    }
}

// MARK: - Extension for HomeController Collection View






