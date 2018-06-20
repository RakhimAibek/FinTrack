//
//  News.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 5/13/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import Foundation
import FirebaseDatabase

class News: NSObject {
    
    //properties of the class News
    var title: String?
    var infoSource: String?
    var datePublication: String?
    var descriptionNews: String?
    var imageLink: String?
    var favourite: Bool?
    var id: String?
    var link: String?
    
    init(title: String, infoSource: String, datePublication: String, description: String, imageLink: String, favourite: Bool) {
        self.title = title
        self.infoSource = infoSource
        self.datePublication = datePublication
        self.descriptionNews = description
        self.imageLink = imageLink
        self.favourite = favourite
        self.id = ""
        self.link = ""
    }
    
    //Firebase init snapshot
    init(snapshot: DataSnapshot) {
        let data = snapshot.value as? NSDictionary
        self.title = data?["title"] as? String ?? ""
        self.infoSource = data?["infoSource"] as? String ?? ""
        self.datePublication = data?["datePublication"] as? String ?? ""
        self.descriptionNews = data?["description"] as? String ?? ""
        self.imageLink = data?["imageLink"] as? String ?? ""
        self.link = data?["link"] as? String ?? ""
    }
    
    init(dictionary: [String: String]) {
        self.title = dictionary["title"]
        self.descriptionNews = dictionary["description"]
        self.imageLink = dictionary["imageLink"]
        self.link = dictionary["link"]
        self.infoSource = dictionary["infoSource"]
        self.datePublication = dictionary["datePublication"]
        
        super.init()
    }
    
    //function for fetching data from Database
    static func fetch(completion: @escaping (([News]?, String?) -> Void)) {

        Database.database().reference().child("News").observe(.value, with: { (snapshot) in

            if let data = snapshot.value as? [String: [String: String]] {
                var newsArr = [News]()
                
                for i in data {
                    let news = News(dictionary: i.value)
                    news.id = i.key
                    newsArr.append(news)
                }
                
                completion(newsArr, nil)
                return
            }
            
            completion(nil, "News fetching error occured")
        })
    }
    
}
