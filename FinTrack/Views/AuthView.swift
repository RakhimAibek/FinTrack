//
//  AuthView.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit

class AuthView: UIView {
    
    // button actions
    var loginAction: (() -> Void)?
    var signupAction: (() -> Void)?
    var laterAction: (() -> Void)?
    
    // -declaring
    private var stackViewButtons: UIStackView!
    private var stackViewContent: UIStackView!
    
    // -declaring in closures
    let containerView1: UIView = {
        let view = UIView()
        return view
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logoApp")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField(placeHolder: "введите email", fontSize: 16)
        tf.tag = 0
        tf.returnKeyType = .next
        tf.autocapitalizationType = .none
        tf.adjustsFontForContentSizeCategory = true
        tf.addLeftImage(textField: tf, imageName: "messageImageTF", imageWidth: 23, imageHeight: 19.46)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField(placeHolder: "введити пароль", fontSize: 16)
        tf.tag = 1
        tf.returnKeyType = .done
        tf.isSecureTextEntry = true
        tf.adjustsFontForContentSizeCategory = true
        tf.autocapitalizationType = .none
        tf.addLeftImage(textField: tf, imageName: "blockImageTF", imageWidth: 23, imageHeight: 19.46)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 0, g: 145, b: 234)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 16)
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 76, g: 185, b: 6)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 16)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let laterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пропусить", for: .normal)
        button.setTitleColor(UIColor(r: 155, g: 155, b: 155), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        button.addTarget(self, action: #selector(laterBTNpressed), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // -setuping UI elements, adding in superview
    private func setupViews() {
        
        self.backgroundColor = .white
        containerView1.addSubview(logoImageView)
        stackViewButtons = createStackViewHorizontal(views: [registerButton, loginButton], spacingNo: 40, distribution: .fillEqually)
        stackViewContent = createStackViewVertical(views: [emailTextField, passwordTextField, stackViewButtons], spacingNo: 15, distribution: .fillEqually)
        
        [containerView1, stackViewContent, laterButton].forEach {
            self.addSubview($0)
        }
    }
    
    // -setuping constraints for UI elements
    private func setupConstraints() {
        
        containerView1.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.frame.width, height: self.frame.height/2.1585))
        
        logoImageView.centerAnchor(to: containerView1)
        logoImageView.setOnlyAnchorSize(size: .init(width: containerView1.frame.width/2.6978, height: containerView1.frame.height/2.1458))
        
        stackViewContent.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 43).isActive = true
        stackViewContent.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        stackViewContent.setOnlyAnchorSize(size: .init(width: self.frame.width/1.1980, height: 180))
        
        laterButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        laterButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: .init(width: 128, height: 16))
        laterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
    }
    
    // -ibactions
    @objc private func registerButtonPressed() {
        signupAction?()
    }
    
    @objc private func loginButtonPressed() {
        loginAction?()
    }
    
    @objc private func laterBTNpressed() {
        laterAction?()
    }
    
}
