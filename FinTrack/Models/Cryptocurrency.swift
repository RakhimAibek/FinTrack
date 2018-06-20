//
//  Cryptocurrency.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

class Cryptocurrency: NSObject {
    
    //MARK: -properties
    var symbol: String?
    var cap: String?
    var price: Double?
    var changeHour: Double?
    var changeDay: Double?
    
    //Currency class initialization declarations
    init(symbol: String, cap: String, price: Double, changeHour: Double, changeDay: Double) {
        self.symbol = symbol
        self.cap = cap
        self.price = price
        self.changeHour = changeHour
        self.changeDay = changeDay
    }
    
}

