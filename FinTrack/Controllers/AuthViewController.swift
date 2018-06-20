//
//  ViewController.swift
//  FinTrack
//
//  Created by Akbota Sakanova on 4/26/18.
//  Copyright © 2018 Akbota Sakanova. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    private var authView: AuthView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        authView.emailTextField.delegate = self
        authView.passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //checkUser is exist or not
        if UserDefaults.standard.object(forKey: "currentUser") != nil {
            let mainTabVC = MainTabBarVC()
            self.present(mainTabVC, animated: true, completion: nil)
        }
    }
    
    // to know which fonts are in xcode
    func printAllFontsName() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }
    
    private func setupViews() {
        let mainView  = AuthView(frame: view.frame)
        self.authView = mainView
        self.authView.loginAction = loginPressed
        self.authView.laterAction = laterPressed
        self.authView.signupAction = signupPressed
        //add to view
        self.view.addSubview(authView)
    }
    
    private func setupConstraints() {
        authView.fillSuperView()
    }
    
    //MARK: -UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField: authView.emailTextField, moveDistance: -40, up: true)
        moveTextField(textField: authView.passwordTextField, moveDistance: -40, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField: authView.emailTextField, moveDistance: -40, up: false)
        moveTextField(textField: authView.passwordTextField, moveDistance: -40, up: false)
    }
    
    //moving keyboard when textfields appear
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    //Hide keyboard when user touches outside keyboar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Hide keyboard when done pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        authView.passwordTextField.resignFirstResponder()
        authView.loginButton.resignFirstResponder()
        authView.registerButton.resignFirstResponder()
        return true
    }
    
    private func laterPressed() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.synchronize()
        let mainTabVC = TabBarVC()
        self.present(mainTabVC, animated: true, completion: nil)
    }
    
    private func loginPressed() {
        guard let userEmail = authView.emailTextField.text else { return }
        guard let userPassword = authView.passwordTextField.text else { return }
        authView.loginButton.loadingIndicator(true)
        authView.loginButton.setTitle("", for: .normal)
        
        //MARK: -Firebase usage
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] user, error in
            if error == nil && user != nil {
//                if (user?.isEmailVerified)! {
                    //save in userDefaults
                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "currentUser")
                    UserDefaults.standard.synchronize()
                    //go to main VC
                    let mainTabVC = MainTabBarVC()
                    self?.present(mainTabVC, animated: true, completion: nil)
//                } else {
//                    print("not verified email")
//                    let alert = UIAlertController(title: "Ваш email не подтвержден", message: "Пожалуйста, подтвердите письмо в \(userEmail)", preferredStyle: .alert)
//                    let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
//                    alert.addAction(action)
//                    self?.present(alert, animated: true, completion: nil)
//                }

            } else {
                let alert = UIAlertController(title: "\(String(describing: error?.localizedDescription ?? ""))", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: false, completion: nil)
            }
            self?.authView.loginButton.setTitle("Войти", for: .normal)
            self?.authView.loginButton.loadingIndicator(false)
        }

    }
    
    // AUTH
    private func signupPressed() {
        guard let userEmail = authView.emailTextField.text else { return }
        guard let userPassword = authView.passwordTextField.text else { return }
        authView.registerButton.loadingIndicator(true)
        authView.registerButton.setTitle("", for: .normal)
        
        //MARK: -Firebase usage
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [weak self] user, error in
            if error == nil && user != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userEmail
                changeRequest?.commitChanges { error in
                    if error == nil {
                        let userRef = Database.database().reference().child("Users").child(user?.uid ?? "")
                        let value = ["email":userEmail,
                                     "favNews":"", "userName":""]
                        //inserting user data in Database
                        userRef.updateChildValues(value, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err ?? "")
                                return
                            }
                            print("succesfully saved user in db")
                            
                            let alert = UIAlertController(title: "Вы успешно зарегистрированы", message: nil, preferredStyle: .alert)
                            
                            let action = UIAlertAction(title: "Отлично!", style: .default, handler: { (action) in
                                let mainTabVC = MainTabBarVC()
                                self?.present(mainTabVC, animated: true, completion: nil)
                            })
                            
                            alert.addAction(action)
                            self?.present(alert, animated: true, completion: nil)
//                            Auth.auth().currentUser?.sendEmailVerification(completion: { (errror) in
//                                if errror != nil {
//                                    print(error?.localizedDescription ?? "")
//                                }
//                                let alert = UIAlertController(title: "Подтвердите свой email", message: "На вашу почту: \         (userEmail) было отправлено письмо", preferredStyle: .alert)
//                                let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
//                                alert.addAction(action)
//                                self?.present(alert, animated: true, completion: nil)
//                            })
                        })
                    }
                }
            } else {
                let alert = UIAlertController(title: "\(String(describing: error?.localizedDescription ?? ""))", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: false, completion: nil)
            }
            self?.authView.registerButton.setTitle("Создать", for: .normal)
            self?.authView.registerButton.loadingIndicator(false)
        }
    }
}

