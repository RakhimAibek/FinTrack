//
//  NewsTableViewCell.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var stackView = UIStackView()
    
    //declaring UIviews
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "default_imageNews")
        return imageView
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite_button"), for: .normal)
        button.setImage(UIImage(named: "favorite_button_selected"), for: .selected)
        return button
    }()
    
    let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 14)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    let labelContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 9)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(r: 155, g: 155, b: 155)
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 9)
        label.textColor = UIColor(r: 0, g: 145, b: 234)
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
        self.newsTitleLabel.text = ""
        self.dateLabel.text = ""
        self.companyLabel.text = ""
        self.newsImageView.image = UIImage(named: "default_imageNews")
        self.favouriteButton.isSelected = false
    }
    
    //setup views
    private func setupViews() {
        stackView = createStackViewVertical(views: [newsTitleLabel, labelContainerView], spacingNo: 1, distribution: .fill)
        
        labelContainerView.addSubview(dateLabel)
        labelContainerView.addSubview(companyLabel)
        
        [newsImageView, favouriteButton, stackView].forEach {
            self.containerView.addSubview($0)
        }
        
        self.addSubview(containerView)
    }
    
    //adding constraints
    private func setupConstraints() {
        containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 0, bottom: 12, right: 0), size: .init(width: 0, height: 0))
        
        newsImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 124))
        
        favouriteButton.anchor(top: newsImageView.bottomAnchor, leading: nil, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 12), size: .init(width: 20, height: 19))
        
        stackView.anchor(top: newsImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: favouriteButton.leadingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 26), size: .init(width: 0, height: 32))
        
        dateLabel.anchor(top: labelContainerView.topAnchor, leading: labelContainerView.leadingAnchor, bottom: labelContainerView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 0))
        companyLabel.anchor(top: labelContainerView.topAnchor, leading: dateLabel.trailingAnchor, bottom: labelContainerView.bottomAnchor, trailing: labelContainerView.trailingAnchor, padding: .init(top: 0, left: 2, bottom: 0, right: 0), size: .init(width: 0, height: 0))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
