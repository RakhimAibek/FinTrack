//
//  Cryptocurrency.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

class ResultConverted: NSObject {
    
    //MARK: -properties
    var result: String?
    var coin: String?
    var currency: String?
    
    //Currency class initialization declarations
    init(result: String, coin: String, currency: String) {
        self.result = result
        self.coin = coin
        self.currency = currency
    }

}


