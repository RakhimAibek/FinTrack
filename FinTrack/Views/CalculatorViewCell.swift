//
//  CalculatorViewCell.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

class CalculatorViewCell: UITableViewCell {
    
    //declarations of UIs in closure
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(r: 89, g: 115, b: 124)
        label.font = UIFont(name: "AvenirNext-Bold", size: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(r: 0, g: 145, b: 234)
        label.font = UIFont(name: "AvenirNext-Bold", size: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    //for avoiding the reusing the each cell
    override func prepareForReuse() {
        super.prepareForReuse()
        self.priceLabel.text = ""
        self.nameLabel.text = ""
    }
    
    private func setupViews() {
        [nameLabel, priceLabel].forEach {
            self.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        nameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.frame.width/3, height: 0))
        
        priceLabel.anchor(top: topAnchor, leading: nameLabel.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
