//
//  UITextField.swift
//  Fintrack
//
//  Created by Akbota Sakanova on 3/18/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

extension UITextField {
    
    public convenience init(placeHolder: String, fontSize: CGFloat) {
        self.init()
        
//        self.borderStyle = .roundedRect
        self.textColor = .black
        self.layer.cornerRadius = 23
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(r: 247, g: 248, b: 250)
        self.layer.borderColor = UIColor(r: 212, g: 220, b: 225).cgColor
        self.layer.borderWidth = 1
        self.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        self.autocorrectionType = .no
        self.clearButtonMode = .whileEditing
        
        // placeholder
        var placeholder = NSMutableAttributedString()
        placeholder = NSMutableAttributedString(attributedString:
            NSAttributedString(string: placeHolder,
                               attributes: [NSAttributedStringKey.font: UIFont(
                               name: "AvenirNext-DemiBold", size: fontSize)!,
                               .foregroundColor: UIColor(red: 147.0/255.0, green: 147.0/255.0, blue: 147.0/255.0, alpha: 1)]))
        self.attributedPlaceholder = placeholder
    }
    
    func addLeftImage(textField: UITextField, imageName: String, imageWidth: Double, imageHeight: Double) {
        leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: imageWidth, height: imageHeight))
        imageView.image = UIImage(named: imageName)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth+25, height: imageHeight))
        view.addSubview(imageView)
        leftView = view
        
    }
    
}



