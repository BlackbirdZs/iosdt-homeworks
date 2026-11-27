//
//  MainViewController.swift
//  DocApp
//
//  Created by Anton Kruglov on 26.11.2026.
//

import KeychainSwift
import UIKit

class LoginViewController: UIViewController {
    private let keyChain = KeyChainService()
    private var isRepeatStep: Bool = false
    private var firstEnteredPassword: String?
    private var firstPassword: String?

    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .black
        passwordTextField.backgroundColor = .systemGray4

        return passwordTextField
    }()

    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 10
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        return loginButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        checkPass()
        // Do any additional setup after loading the view.
    }

    func showTabBar() {
        let tableNav = UINavigationController(rootViewController: MainTableViewController())
        let settingsNav = UINavigationController(rootViewController: SettingsTableViewController())
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [tableNav, settingsNav]
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.unselectedItemTintColor = .systemGray
        tabBarController.selectedIndex = 0
        tableNav.tabBarItem.title = "Files"
        tableNav.tabBarItem.image = UIImage(systemName: "folder.fill")
        settingsNav.tabBarItem.title = "Settings"
        settingsNav.tabBarItem.image = UIImage(systemName: "gear")
        view.window?.rootViewController = tabBarController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetState()
        checkPass()
    }

    func resetState() {
        isRepeatStep = false
        firstPassword = nil
        loginButton.setTitle("Create password", for: .normal)
        passwordTextField.text = ""
    }

    func checkPass() {
        if let savedPass = keyChain.getPassword(), !savedPass.isEmpty {
            loginButton.setTitle("Enter the password", for: .normal)
        } else {
            loginButton.setTitle("Create password", for: .normal)
        }
    }

    @objc func loginButtonTapped() {
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please, enter the password")
            return
        } // 1
        guard password.count >= 4 else {
            showAlert(message: "Password must be equal or less than 4 symbols")
            return
        } // 2
        let savedPassword = keyChain.getPassword()
        if savedPassword == nil || savedPassword?.isEmpty == true {
            if !isRepeatStep {
                firstPassword = password
                isRepeatStep = true
                loginButton.setTitle("Repeat password", for: .normal)
                passwordTextField.text = ""
            } else {
                if password == firstPassword {
                    keyChain.savePassword(password)
                    showTabBar()
                } else {
                    showAlert(message: "Password doesnt match")
                    resetState()
                }
            }
        } else {
            if password == savedPassword {
                showTabBar()
            } else {
                showAlert(message: "Wrong password")
            }
        }
    }

        func setupView() {
            view.backgroundColor = .systemGray5
        }

        func addSubviews() {
            view.addSubview(passwordTextField)
            view.addSubview(loginButton)
        }

        func setupConstraints() {
            NSLayoutConstraint.activate([
                passwordTextField.widthAnchor.constraint(equalToConstant: 200),
                passwordTextField.heightAnchor.constraint(equalToConstant: 40),
                passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),

                loginButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
                loginButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
                loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
                loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ]
            )
        }

        func showAlert(message: String) {
            let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(doneAction)
            present(alert, animated: true)
        }
}
