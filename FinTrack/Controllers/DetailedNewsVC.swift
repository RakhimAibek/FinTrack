//
//  DetailedNewsVC.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit
import Firebase

class DetailedNewsVC: UIViewController {
    
    var selectedNews: News?
    var detailedView: DetailedNewsView!
    var favNews: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        guard let news = selectedNews else { return }
        detailedView.companyLabel.text = news.infoSource
        detailedView.dateLabel.text = news.datePublication
        detailedView.descriptionNewsLabel.text = news.descriptionNews
        detailedView.newsTitleLabel.text = news.title
        detailedView.favouriteButton.isSelected = (news.favourite ?? false) ? true : false
        
        //setuping navBar title
        self.setCustomNavBar(leftBarBTNimage: "arrow_back_button", leftSelectorFunc: #selector(backBTNpressed), rightBarBTNimage: "share_button", rightSelectorFunc: #selector(shareButtonPressed), title: news.infoSource)
        
        //for asynchronic downloading the image
        DispatchQueue.main.async {
            self.detailedView.detailedNewsImageView.imageFromURL(urlString: news.imageLink!)
        }
    }
    
    //adding views to superview
    private func setupViews() {
        let mainView = DetailedNewsView(frame: self.view.frame)
        detailedView = mainView
        
        if UserDefaults.standard.object(forKey: "currentUser") != nil {
            detailedView.favoriteAction = favoriteButtonPressed
        }
        self.view.addSubview(detailedView)
    }
    
    //setuping constraints for UIs
    private func setupConstraints() {
        detailedView.anchor(top: view.safeTopAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -100, right: 0), size: .init(width: 0, height: 0))
    }
    
    @objc private func backBTNpressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonPressed() {
        (self.selectedNews?.link ?? "").share()
    }
    
    @objc private func favoriteButtonPressed() {
        if (selectedNews?.favourite ?? false) {
            var favArray = favNews.components(separatedBy: ",")
            favArray.remove(at: favArray.index(of: selectedNews?.id ?? "")!)
            favNews = favArray.joined(separator: ",")
            let updateData: [String: String] = ["favNews": favNews]
            Database.database().reference().child("Users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(updateData) { (err, reference) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    self.selectedNews?.favourite = false
                    self.detailedView.favouriteButton.isSelected = false
                }
            }
        } else {
            if favNews != "" {
                favNews.append(",")
            }
            favNews.append(selectedNews?.id ?? "")
            let updateData: [String: String] = ["favNews": favNews]
            Database.database().reference().child("Users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(updateData) { (err, reference) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    self.selectedNews?.favourite = true
                    self.detailedView.favouriteButton.isSelected = true
                }
            }
        }
    }

}
