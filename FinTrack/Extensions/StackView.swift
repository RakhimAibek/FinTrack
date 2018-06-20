//
//  StackView.swift
//  Fintrack
//
//  Created by Akbota Sakanova on 4/25/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

extension UIView {
    
    func createStackViewVertical(views: [UIView], spacingNo: CGFloat, distribution: UIStackViewDistribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.distribution = distribution
        stackView.spacing = spacingNo
        return stackView
    }
    
    func createStackViewHorizontal(views: [UIView],  spacingNo: CGFloat, distribution: UIStackViewDistribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.distribution = distribution
        stackView.spacing = spacingNo
        return stackView
    }
    
}

