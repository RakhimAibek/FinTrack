//
//  MainTabBarVC.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.layer.borderColor = UIColor(r: 178, g: 178, b: 178).cgColor
        self.tabBar.layer.borderWidth = 0.3
        self.tabBar.tintColor = UIColor(r: 0, g: 145, b: 234)
        self.tabBar.isTranslucent = false
        
        //MARK: -Setting TabBat ViewControllers
        let marketVC = UINavigationController(rootViewController: MarketViewController())
        marketVC.tabBarItem.title = "Рынок"
        marketVC.tabBarItem.image = UIImage(named: "market_icon")
        marketVC.tabBarItem.selectedImage = UIImage(named: "market_iconActive")?.withRenderingMode(.alwaysOriginal)
        
        let newsVC = UINavigationController(rootViewController: NewsViewController())
        newsVC.tabBarItem.title = "Новости"
        newsVC.tabBarItem.image = UIImage(named: "news_icon")
        newsVC.tabBarItem.selectedImage = UIImage(named: "news_iconActive")?.withRenderingMode(.alwaysOriginal)
        
        let calcVC = UINavigationController(rootViewController: CalculatorViewController())
        calcVC.tabBarItem.title = "Калькулятор"
        calcVC.tabBarItem.image = UIImage(named: "calculator_icon")
        calcVC.tabBarItem.selectedImage = UIImage(named: "calculator_iconActive")?.withRenderingMode(.alwaysOriginal)
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem.title = "Профиль"
        profileVC.tabBarItem.image = UIImage(named: "profile_icon")
        profileVC.tabBarItem.selectedImage = UIImage(named: "profile_iconActive")?.withRenderingMode(.alwaysOriginal)

        self.viewControllers = [marketVC, newsVC, calcVC, profileVC]
        
        

    }
    
}
