//
//  ProfileViewController.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let myCellID = "profileCellID"
    private var profileDataStackView: UIStackView!
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_app_profile")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.textAlignment = .center
        label.text = "Имя Фамилия"
        label.textColor = UIColor(r: 3, g: 3, b: 3)
        label.adjustsFontSizeToFitWidth = true
        label.addBottomBorderWithColor(color: UIColor(r: 0, g: 145, b: 234), width: 1)
        return label
    }()
    
    let userEmail: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.textAlignment = .center
        label.text = "mail@gmail.com"
        label.textColor = UIColor(r: 3, g: 3, b: 3)
        label.adjustsFontSizeToFitWidth = true
        label.addBottomBorderWithColor(color: UIColor(r: 0, g: 145, b: 234), width: 1)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        self.setCustomNavBar(leftBarBTNimage: nil, leftSelectorFunc: nil, rightBarBTNimage: nil, rightSelectorFunc: nil, title: "Профиль")
        
        userEmail.text = Auth.auth().currentUser?.email ?? "mail@mail.com"
        Database.database().reference().child("Users").child(Auth.auth().currentUser?.uid ?? "").observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? NSDictionary else { return }
            guard let userName = dictionary["userName"] as? String else { return }
            self.userName.text = userName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserName()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        profileDataStackView = view.createStackViewVertical(views: [userName, userEmail], spacingNo: 10, distribution: .fillEqually)
        
        //setuping UITableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 41
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: myCellID)
        
        //adding UIs
        [profileImageView, profileDataStackView, tableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    //MARK: - setuping constraints
    private func setupConstraints() {
        profileImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 90, height: 90))
        
        profileDataStackView.anchor(top: view.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 31, left: 16, bottom: 0, right: 34), size: .init(width: 0, height: 60))
        
        tableView.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 60, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: 200))
        
    }
    
    //check User has name or not
    private func checkUserName() {
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in

            if let data = snapshot.value as? [String: String] {
                let userName = data["userName"]
                
                if userName == "" {
                let alert = UIAlertController(title: "Привет!", message: "Заполните данные", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Введите свое имя"
                    textField.autocapitalizationType = .words
                    textField.autocorrectionType = .no
                }
                
                let action = UIAlertAction(title: "Да", style: .default, handler: { action in
                    guard let userName = alert.textFields![0].text else { return }
                    let updateData: [String: String] = ["userName" : userName]
                    Database.database().reference().child("Users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(updateData, withCompletionBlock: { (err, reference) in
                        if let error = err {
                            print(error.localizedDescription)
                        } else {
                            
                        }
                    })
                })
                
                let cancel = UIAlertAction(title: "Нет", style: .destructive, handler: nil)
                
                alert.addAction(action)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    //MARK: UITableViewDatasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellID, for: indexPath)
        cell.selectionStyle = .none
        
        //setuping textLabel
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Мои избранные новости"
        case 1:
            cell.textLabel?.text = "Изменить данные"
        case 2:
            cell.textLabel?.text = "Выход"
            cell.textLabel?.textColor = UIColor(r: 244, g: 85, b: 49)
        default:
            break
        }
        
        //cell properties setuping
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //sign out action
        
        switch indexPath.row {
        case 0:
            let myFavpriteVC = MyFavoriteNewsVC()
            navigationController?.pushViewController(myFavpriteVC, animated: true)
        case 1:
            let alert = UIAlertController(title: "Как Вас зовут?", message: "Ваше имя будет отображено в профиле", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Введите свое имя"
                textField.autocapitalizationType = .words
                textField.autocorrectionType = .no
            }
            
            let action = UIAlertAction(title: "Да", style: .default, handler: { action in
                guard let userName = alert.textFields![0].text else { return }
                let updateData: [String: String] = ["userName" : userName]
                Database.database().reference().child("Users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(updateData, withCompletionBlock: { (err, reference) in
                    if let error = err {
                        print(error.localizedDescription)
                    } else {
                        
                    }
                })
            })
            
            let cancel = UIAlertAction(title: "Нет", style: .destructive, handler: nil)
            
            alert.addAction(action)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        case 2:
            let alert = UIAlertController(title: "Вы хотите выйти из своего профиля?", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Да", style: .default, handler: { [weak self] (UIAlertAction) in
                
                do {
                    try Auth.auth().signOut()
                    let vc = AuthViewController()
                    UserDefaults.standard.removeObject(forKey: "currentUser")
                    UserDefaults.standard.synchronize()
                    self?.present(vc, animated: true, completion: nil)
                    
                } catch let signOutError as NSError {
                    print(signOutError.localizedDescription)
                }
            })
            
            let cancel = UIAlertAction(title: "Нет", style: .destructive, handler: nil)
            
            alert.addAction(action)
            alert.addAction(cancel)
            
            self.present(alert, animated: false, completion: nil)
        default:
            break
        }
    }
}
