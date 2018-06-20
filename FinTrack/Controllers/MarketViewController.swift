//
//  MarketViewController.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MarketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //declaring UIs
    let headerSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Название", "Ситуация", "USD"])
        sc.tintColor = .white
        sc.backgroundColor = UIColor(r: 0, g: 145, b: 234)
        sc.addTarget(self, action: #selector(changeCurrency(sender:)), for: .valueChanged)
        return sc
    }()
    
    let clickToChangeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "swap_icon")
        return imageView
    }()
    
    let tableView = UITableView()
    var cryptoCurrencyArray: [Cryptocurrency] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // API 
        fetchData(url: "https://chasing-coins.com/api/v1/top-coins/50")
        setupViews()
        setupConstrains()
        
        self.setCustomNavBar(leftBarBTNimage: nil, leftSelectorFunc: nil, rightBarBTNimage: nil, rightSelectorFunc: nil, title: "Криптовалюты")
    }
    
    //setuping views
    private func setupViews() {
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 58
        tableView.register(MarketTableViewCell.self, forCellReuseIdentifier: "myCell")
        
        [headerSegmentedControl, clickToChangeImageView, tableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    //adding constraints
    private func setupConstrains() {
        headerSegmentedControl.anchor(top: view.safeTopAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 33))
        
        clickToChangeImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: headerSegmentedControl.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20), size: .init(width: 12, height: 16))
        clickToChangeImageView.centerYAnchor.constraint(equalTo: headerSegmentedControl.centerYAnchor).isActive = true
        
        tableView.anchor(top: headerSegmentedControl.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }
    // API
    private func fetchData(url: String) {
        //Alamofire usage - alomofire to retrieve the JSON data
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
                
            case .success(let value):
                //JSON - SwiftyJSON usage - SwiftyJSON is to working with the results from JSON
                let json = JSON(value)
                
                for i in 1...50 {
                    let firstPath = json["\(i)"].dictionaryValue
                    
                    //name of cryptocurrency
                    let symbol = firstPath["symbol"]?.stringValue ?? ""
                    
                    //capitalization of cryptocurrency
                    let cap = firstPath["cap"]?.stringValue ?? ""
                    
                    //last change of cryptocurrency
                    let change = firstPath["change"]?.dictionaryValue
                    let changeHour = change!["hour"]?.doubleValue ?? 0.0
                    let changeDay = change!["day"]?.doubleValue ?? 0.0
                    
                    //price of cryptocurrency
                    let price = firstPath["price"]?.doubleValue ?? 0.0
                    
                    self.cryptoCurrencyArray.append(Cryptocurrency(symbol: symbol, cap: cap, price: price, changeHour: changeHour, changeDay: changeDay))
                    
                    self.tableView.reloadData()
                }
                
                //send data to other ViewController
                if let navController = self.tabBarController?.viewControllers![2] as! UINavigationController? {
                    if let controller = navController.viewControllers.first as! CalculatorViewController? {
                        if controller.cryptsNameListArr.isEmpty {
                            for i in 0...49 {
                                controller.cryptsNameListArr.append(self.cryptoCurrencyArray[i].symbol ?? "")
                            }
                            controller.cryptsNameListArr.insert("RUR", at: 0)
                            controller.cryptsNameListArr.insert("EUR", at: 0)
                            controller.cryptsNameListArr.insert("KZT", at: 0)
                            controller.cryptsNameListArr.insert("USD", at: 0)
                        }
                    }
                }
                
            case .failure(let error):
                print("failed", error)
            }
        }
    }
    
    @objc private func changeCurrency(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 2 {
            switch sender.titleForSegment(at: 2)! {
            case "USD":
                sender.setTitle("ТЕНГЕ", forSegmentAt: 2)
            case "ТЕНГЕ":
                sender.setTitle("РУБЛЬ", forSegmentAt: 2)
            case "РУБЛЬ":
                sender.setTitle("ЕВРО", forSegmentAt: 2)
            case "ЕВРО":
                sender.setTitle("USD", forSegmentAt: 2)
            default:
                break
            }
            tableView.reloadData()
        }
        sender.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    //MARK: - uitableview delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoCurrencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MarketTableViewCell
        cell.isUserInteractionEnabled = false

        if !cryptoCurrencyArray.isEmpty {
            cell.nameCoin.text = "\(String(describing: cryptoCurrencyArray[indexPath.row].symbol!))"
            
            //to convert coins for each currency by pressing headerSegmentedControl
            switch headerSegmentedControl.titleForSegment(at: 2)! {
            case "USD":
                cell.currentPrice.text = "\(NumberFormatter.localizedString(from: NSNumber(value: cryptoCurrencyArray[indexPath.row].price!), number: NumberFormatter.Style.decimal))"
            case "ТЕНГЕ":
                let kzt = Int(cryptoCurrencyArray[indexPath.row].price!*327.9)
                cell.currentPrice.text = "\(NumberFormatter.localizedString(from: NSNumber(value:kzt), number: NumberFormatter.Style.decimal))"
            case "РУБЛЬ":
                let rur = Int(cryptoCurrencyArray[indexPath.row].price!*61.904)
                cell.currentPrice.text = "\(NumberFormatter.localizedString(from: NSNumber(value: rur), number: NumberFormatter.Style.decimal))"
            case "ЕВРО":
                let eur = Int(cryptoCurrencyArray[indexPath.row].price!*0.836)
                cell.currentPrice.text = "\(eur)"
            default:
                break
            }
            
            let changeHour = cryptoCurrencyArray[indexPath.row].changeHour ?? 0.0
            cell.situation.text = "\(changeHour)%"
            if changeHour > 0.0 {
                if changeHour > 3.0 {
                    cell.situation.textColor = UIColor(r: 76, g: 185, b: 6)
                    cell.currentPrice.backgroundColor = UIColor(r: 7, g: 185, b: 6) //green
                } else {
                    cell.currentPrice.backgroundColor = UIColor(r: 0, g: 145, b: 234)
                }
            } else if changeHour < 0.0 {
                cell.situation.textColor = UIColor(r: 244, g: 85, b: 49)
                cell.currentPrice.backgroundColor = UIColor(r: 244, g: 85, b: 49) // red
            }
            //download images for each coins from internet
            cell.coinImageView.imageFromURL(urlString: "https://chasing-coins.com/api/v1/std/logo/"+cryptoCurrencyArray[indexPath.row].symbol!)
        }
        
        return cell
    }
    
}
