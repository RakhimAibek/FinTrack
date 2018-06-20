//
//  MyFavoriteNewsVC.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit
import Firebase

class MyFavoriteNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let favoriteCellID = "favoriteCellId"
    var newsList = [News]()
    var ref: DatabaseReference?
    var favNews: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        //setting navigation bar
        self.setCustomNavBar(leftBarBTNimage: nil, leftSelectorFunc: nil, rightBarBTNimage: nil, rightSelectorFunc: nil, title: "Мои избранные")
        
        //Fetch data
        fetchNewsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    //adding UIs to superview
    private func setupViews() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 187
        self.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: favoriteCellID)
        
        self.view.addSubview(tableView)
    }
    
    //adding constraints
    private func setupConstraints() {
        tableView.anchor(top: view.safeTopAnchor, leading: view.leadingAnchor, bottom: view.safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }
    //fetching data
    private func fetchNewsList() {
        News.fetch { (news, error) in
            guard let news = news else {
                print(error ?? "error News.fetch fetching")
                return
            }
            self.newsList.removeAll()
            
            //sorting by date
            self.newsList = self.newsList.sorted(by: {(news1, news2) in
                let sortedValue = news1.datePublication?.toDate.compare((news2.datePublication?.toDate)!) == .orderedDescending
                return sortedValue
            })
            Database.database().reference().child("Users").child(Auth.auth().currentUser?.uid ?? "").child("favNews").observe(.value, with: { (snapshot) in
                self.newsList.removeAll()
                guard let favNews = snapshot.value as? String else { return }
                self.favNews = favNews
                if favNews != "" {
                    let favNewsArray = favNews.components(separatedBy: ",")
                    news.forEach({ (it) in
                        if (favNewsArray.contains(it.id ?? "")) {
                            it.favourite = true
                            self.newsList.append(it)
                        }
                    })
                }
                self.tableView.reloadData()
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteCellID, for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        
        let news = newsList[indexPath.row]
        
        cell.newsTitleLabel.text = "\(news.title ?? "")"
        cell.dateLabel.text = "\(String(describing: news.datePublication ?? ""))"
        cell.companyLabel.text = "\(String(describing: news.infoSource ?? ""))"
        
        //download images for each coins from internet
        cell.newsImageView.imageFromURL(urlString: news.imageLink ?? "")
        if (news.favourite ?? false) { cell.favouriteButton.isSelected = true }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        let detailedVC = DetailedNewsVC()
        detailedVC.selectedNews = news
        detailedVC.favNews = self.favNews
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
}
