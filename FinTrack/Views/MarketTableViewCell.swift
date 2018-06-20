//
//  MarketTableViewCell.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/27/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

class MarketTableViewCell: UITableViewCell {
    
    //declarations
    let chartDataHistory = [Double]()
    var stackView1: UIStackView!
    
    let situation: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 89, g: 115, b: 124)
        label.font = UIFont(name: "AvenirNext-Bold", size: 16)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let currentPrice: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        label.textColor = .white
        label.text = "$8,575"
        label.textAlignment = .center
        return label
    }()
    
    let nameViewSection: UIView = {
        let view = UIView()
        return view
    }()
    
    let nameCoin: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(r: 89, g: 115, b: 124)
        label.font = UIFont(name: "AvenirNext-Bold", size: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 24, height: 24)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //for avoiding the reusing the each cell
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameCoin.text = ""
        self.situation.text = ""
        self.currentPrice.text = ""
        self.currentPrice.backgroundColor = .white
        self.situation.textColor = UIColor(r: 89, g: 115, b: 124)
        self.coinImageView.image = UIImage(named: "loading_icon")
    }
    
    private func setupViews() {
        stackView1 = createStackViewHorizontal(views: [nameViewSection, situation, currentPrice], spacingNo: 25, distribution: .fillEqually)
        
        nameViewSection.addSubview(coinImageView)
        nameViewSection.addSubview(nameCoin)
        
        [stackView1].forEach {
            self.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        stackView1.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 38))
        stackView1.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        coinImageView.anchor(top: nil, leading: nameViewSection.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 22, height: 22))
        coinImageView.centerYAnchor.constraint(equalTo: nameViewSection.centerYAnchor).isActive = true
        
        nameCoin.anchor(top: nil, leading: coinImageView.trailingAnchor, bottom: nil, trailing: nameViewSection.trailingAnchor, padding: .init(top: 0, left: 2, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        nameCoin.centerYAnchor.constraint(equalTo: nameViewSection.centerYAnchor).isActive = true
    }

}
