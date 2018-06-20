//
//  CalculatorViewController.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CalculatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CryptoCurrencyListVCDelegate {
    
    //properties
    var resultArray = [ResultConverted]()
    var cryptsNameListArr = [String]()
    
    let tableView = UITableView()
    var inputValueTextField:Double = 0
    let cellID = "calculatorCell"
    
    let sellInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Продаете"
        label.textColor = UIColor(r: 155, g: 155, b: 155)
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        return label
    }()
    
    let sellInputContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(r: 0, g: 145, b: 234).cgColor
        return view
    }()
    
    let separatorLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 244, g: 85, b: 49)
        return view
    }()
    
    let otherExValueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "inputValueChange_icon")
        return imageView
    }()
    
    let exchangeCurrencyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.setTitleColor(UIColor(r: 3, g: 3, b: 3), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(exchangeFromCurrency), for: .touchUpInside)
        return button
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите"
        textField.keyboardType = .numberPad
        textField.adjustsFontSizeToFitWidth = true
        textField.textColor = UIColor(r: 3, g: 3, b: 3)
        textField.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        return textField
    }()
    
    let exchangeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 155, g: 155, b: 155)
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        button.setTitle("Сначала выберите", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        button.addTarget(self, action: #selector(exchangeBTNpressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        inputTextField.delegate = self
        self.setCustomNavBar(leftBarBTNimage: nil, leftSelectorFunc: nil, rightBarBTNimage: nil, rightSelectorFunc: nil, title: "Онлайн режим")
        
        if !cryptsNameListArr.isEmpty {
            cryptsNameListArr.forEach { (it) in
                self.resultArray.append(ResultConverted(result: "", coin: "", currency: it))
            }
            tableView.reloadData()
        }

    }
    
    //adding UI views to superview
    private func setupViews() {
        self.view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 37
        tableView.register(CalculatorViewCell.self, forCellReuseIdentifier: cellID)
        
        [sellInfoLabel, sellInputContainerView, exchangeCurrencyButton, separatorLine1,
         otherExValueImageView, inputTextField, exchangeButton, tableView].forEach {
            self.view.addSubview($0)
        }
        
    }
    
    //setuping constraitns of UIs
    private func setupConstraints() {
        
        sellInfoLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 6, bottom: 0, right: 6), size: .init(width: 0, height: 0))
        
        sellInputContainerView.anchor(top: sellInfoLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 2, left: 6, bottom: 0, right: 6), size: .init(width: 0, height: 40))
        
        separatorLine1.anchor(top: sellInputContainerView.topAnchor, leading: sellInputContainerView.leadingAnchor, bottom: sellInputContainerView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 100, bottom: 0, right: 0), size: .init(width: 1, height: 0))
        
        otherExValueImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: separatorLine1.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 4), size: .init(width: 12, height: 15))
        otherExValueImageView.centerYAnchor.constraint(equalTo: sellInputContainerView.centerYAnchor).isActive = true
        
        exchangeCurrencyButton.anchor(top: nil, leading: sellInputContainerView.leadingAnchor, bottom: nil, trailing: otherExValueImageView.leadingAnchor, padding: .init(top: 0, left: 6, bottom: 0, right: 6), size: .init(width: 0, height: 0))
        exchangeCurrencyButton.centerYAnchor.constraint(equalTo: sellInputContainerView.centerYAnchor).isActive = true
        
        inputTextField.anchor(top: nil, leading: separatorLine1.trailingAnchor, bottom: nil, trailing: sellInputContainerView.trailingAnchor, padding: .init(top: 0, left: 6, bottom: 0, right: 6), size: .init(width: 0, height: 0))
        inputTextField.centerYAnchor.constraint(equalTo: sellInputContainerView.centerYAnchor).isActive = true
        
        exchangeButton.anchor(top: inputTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 14, left: 6, bottom: 0, right: 6), size: .init(width: 0, height: 40))

        tableView.anchor(top: exchangeButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 14, left: 0, bottom: 0, right: 0))
    }
    
    //MARK: - if inputTextField is empty - off exchange button
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty  {
            inputValueTextField = Double(text)!
            if exchangeCurrencyButton.title(for: .normal) != "Выбрать" {
                exchangeButton.isUserInteractionEnabled = true
                exchangeButton.backgroundColor = UIColor(r: 244, g: 85, b: 49)
                exchangeButton.setTitle("Посмотреть результат", for: .normal)
            }

        } else {
            exchangeButton.isUserInteractionEnabled = false
            exchangeButton.backgroundColor = UIColor(r: 155, g: 155, b: 155)
            exchangeButton.setTitle("Сначала выберите", for: .normal)
        }
        return true
    }
    
    @objc private func exchangeFromCurrency() {
        let currencyListVC = CryptoCurrencyListVC()
        currencyListVC.cryptsArr = self.cryptsNameListArr
        currencyListVC.selectedCurrency = exchangeCurrencyButton.title(for: .normal)
        currencyListVC.delegate = self
        navigationController?.pushViewController(currencyListVC, animated: true)
    }
    
    //MARK: -CryptoCurrencyListVCDelegate method
    func updateCurrency(currency: String) {
        exchangeCurrencyButton.setTitle(currency, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if exchangeCurrencyButton.title(for: .normal) != "Выбрать" && !(inputTextField.text?.isEmpty)! {
            exchangeButton.backgroundColor = UIColor(r: 244, g: 85, b: 49)
            exchangeButton.setTitle("Посмотреть результат", for: .normal)
            exchangeButton.isUserInteractionEnabled = true
        }
    }
    
    //Function after pressing the exchange button pressed
    @objc private func exchangeBTNpressed() {
        self.view.endEditing(true)

        for i in 0...53 {
            fetchConvertResult(from: exchangeCurrencyButton.title(for: .normal)!, to: cryptsNameListArr[i])
        }
        
        resultArray.removeAll()
    }
    
    //MARK: -Parsing result of converting via API
    private func fetchConvertResult(from: String, to: String) {
        let url = "https://chasing-coins.com/api/v1/convert/"+from+"/"+to
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
                
            case .success(let value):
                //JSON - SwiftyJSON usage - SwiftyJSON is to working with the results from JSON
                let json = JSON(value)
            
                self.resultArray.append(ResultConverted(result: json["result"].stringValue, coin: json["coin"].stringValue, currency: json["currency"].stringValue))
                
                self.tableView.reloadData()
                
            case .failure(let error):
                print("failed", error.localizedDescription)
            }
        }

    }
    
    //MARK: UITableViewDatasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view1 = UIView()
        let label = UILabel()
        view1.addSubview(label)
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        label.text = "Получаете"
        label.textColor = UIColor(r: 155, g: 155, b: 155)
        label.textAlignment = .center
        view1.backgroundColor = .white
        label.anchor(top: view1.topAnchor, leading: view1.leadingAnchor, bottom: view1.bottomAnchor, trailing: view1.trailingAnchor, padding: .init(top: 2, left: 40, bottom: 2, right: 40), size: .init(width: 0, height: 0))
        return view1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CalculatorViewCell
        cell.selectionStyle = .none
        
        if !resultArray.isEmpty && inputValueTextField != 0 {
            cell.nameLabel.text = "  \(indexPath.row+1).\(resultArray[indexPath.row].currency!)"
            cell.priceLabel.text = "  \(NumberFormatter.localizedString(from: NSNumber(value: Double(resultArray[indexPath.row].result!)!*inputValueTextField), number: NumberFormatter.Style.decimal))"
        } else {
            cell.nameLabel.text = "  \(indexPath.row+1).\(resultArray[indexPath.row].currency!)"
            cell.priceLabel.text = ""
        }
        
        return cell
    }

}
