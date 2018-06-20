//
//  CryptoCurrencyListVC.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

protocol CryptoCurrencyListVCDelegate {
    func updateCurrency(currency: String)
}

class CryptoCurrencyListVC: UITableViewController {
    
    var cryptsArr = [String]()
    let myCellId = "currencyListID"
    var delegate: CryptoCurrencyListVCDelegate!
    var selectedCurrency: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: myCellId)
        self.setCustomNavBar(leftBarBTNimage: nil, leftSelectorFunc: nil, rightBarBTNimage: nil, rightSelectorFunc: nil, title: "Список")
    }
    
    //MARK: -UITableViewDelegate and Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptsArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row+1). \(cryptsArr[indexPath.row])"
        cell.selectionStyle = .none
        cell.accessoryType = cryptsArr[indexPath.row] == selectedCurrency ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            delegate.updateCurrency(currency: cryptsArr[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}
