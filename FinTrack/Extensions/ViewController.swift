//
//  ViewController.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: - for UIViewControllers to setup custom navBar
    func setCustomNavBar(leftBarBTNimage: String?, leftSelectorFunc: Selector?, rightBarBTNimage: String?, rightSelectorFunc: Selector?, title: String?) {
        
        if leftBarBTNimage != nil && leftSelectorFunc != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: leftBarBTNimage!)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: leftSelectorFunc!)
        }
        
        if rightBarBTNimage != nil && rightSelectorFunc != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: rightBarBTNimage!)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: rightSelectorFunc!)
        }
        
        if title != nil {
            navigationItem.title = title!
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 18.0)!, NSAttributedStringKey.foregroundColor: UIColor(r: 3, g: 3, b: 3)]
        }
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - set only title from UINavigationBar
    func setTitleNavBar(title: String?) {
        
        if title != nil {
            self.navigationItem.titleView = UIImageView(image: UIImage(named: title!))
        }

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(r: 250, g: 250, b: 250)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension UIApplication {
    
    class var topViewController: UIViewController? {
        return getTopViewController()
    }
    
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Equatable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}
