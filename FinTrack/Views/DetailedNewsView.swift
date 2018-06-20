//
//  DetailedNewsView.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

class DetailedNewsView: UIView {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.backgroundColor = .white
        return sv
    }()
    
    let containerView: UIView = {
        let v = UIView()
        return v
    }()
    
    let detailedNewsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_imageNews")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var favoriteAction: (() -> Void)?
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite_button"), for: .normal)
        button.setImage(UIImage(named: "favorite_button_selected"), for: .selected)
        button.addTarget(self, action: #selector(favoriteHandle), for: .touchUpInside)
        return button
    }()
    
    let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 14)
        label.text = "Эфириум инвестировал 14 млн $ в создание платформы для соединения всех биткоинов в одну систему"
        label.numberOfLines = 5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 9)
        label.adjustsFontSizeToFitWidth = true
        label.text = "27 апреля 2018"
        label.textColor = UIColor(r: 155, g: 155, b: 155)
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 9)
        label.textColor = UIColor(r: 0, g: 145, b: 234)
        label.text = "forklog"
        return label
    }()
    
    let descriptionNewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //adding views
    private func setupViews() {
        scrollView.contentSize = CGSize(width: self.frame.width, height: 0)
        
        [detailedNewsImageView, favouriteButton, newsTitleLabel, dateLabel,
         companyLabel, descriptionNewsLabel].forEach {
            self.containerView.addSubview($0)
        }
        
        self.scrollView.addSubview(containerView)
        self.addSubview(scrollView)
    }
    
    //setuping constraints of each UIs
    private func setupConstraints() {
        scrollView.fillSuperView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        containerView.fillSuperView()
        containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        detailedNewsImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: containerView.frame.width, height: 170))
        
        favouriteButton.anchor(top: detailedNewsImageView.bottomAnchor, leading: nil, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 16), size: .init(width: 20, height: 19))
        
        newsTitleLabel.anchor(top: detailedNewsImageView.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: favouriteButton.leadingAnchor, padding: .init(top: 6, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 0))
        
        dateLabel.anchor(top: newsTitleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        companyLabel.anchor(top: newsTitleLabel.bottomAnchor, leading: dateLabel.trailingAnchor, bottom: nil, trailing: favouriteButton.leadingAnchor, padding: .init(top: 4, left: 5, bottom: 0, right: 16), size: .init(width: 0, height: 0))
        
        descriptionNewsLabel.anchor(top: dateLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 10, left: 16, bottom: 40, right: 16))
    }
    
    
    
    @objc func favoriteHandle() {
        favoriteAction?()
    }
}
