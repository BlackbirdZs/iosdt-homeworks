//
//  PasswordChangeViewController.swift
//  DocApp
//
//  Created by Anton Kruglov on 27.11.2026.
//

import UIKit

class PasswordChangeViewController: UIViewController {
    private let keyChain = KeyChainService()

    private lazy var currentPasswordTextField: UITextField = {
        let currentPasswordTextField = UITextField()
        currentPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        currentPasswordTextField.borderStyle = .roundedRect
        currentPasswordTextField.placeholder = "Current password..."
        currentPasswordTextField.textColor = .black
        currentPasswordTextField.isSecureTextEntry = true
        currentPasswordTextField.backgroundColor = .systemGray4

        return currentPasswordTextField
    }()

    private lazy var newPasswordTextField: UITextField = {
        let newPasswordTextField = UITextField()
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.borderStyle = .roundedRect
        newPasswordTextField.placeholder = "New password..."
        newPasswordTextField.textColor = .black
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.backgroundColor = .systemGray4

        return newPasswordTextField
    }()

    private lazy var updatePasswordButton: UIButton = {
        let updatePasswordButton = UIButton()
        updatePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        updatePasswordButton.clipsToBounds = true
        updatePasswordButton.layer.cornerRadius = 10
        updatePasswordButton.setTitle("Update password", for: .normal)
        updatePasswordButton.setTitleColor(.white, for: .normal)
        updatePasswordButton.backgroundColor = .systemTeal
        updatePasswordButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)

        return updatePasswordButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
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
    }

    func resetState() {
        currentPasswordTextField.text = ""
        newPasswordTextField.text = ""
    }

    @objc func updateButtonTapped() {
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty, let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(message: "Please, fill the fields with current and new password")
            return
        } // 1
        guard newPassword.count >= 4 else {
            showAlert(message: "New password must be equal or less than 4 symbols")
            return
        } // 2
        guard let savedPassword = keyChain.getPassword() else {
            showAlert(message: "No password found")
            return
        }
        guard currentPassword == savedPassword else {
            showAlert(message: "Please, enter correct current password")
            return
        }
        keyChain.updatePassword(newPassword)
        showAlert(message: "Password successfully updated!")
        resetState()
        
    }

    func setupView() {
        view.backgroundColor = .systemGray5
    }

    func addSubviews() {
        view.addSubview(currentPasswordTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(updatePasswordButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            currentPasswordTextField.widthAnchor.constraint(equalToConstant: 200),
            currentPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            currentPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            newPasswordTextField.widthAnchor.constraint(equalTo: currentPasswordTextField.widthAnchor),
            newPasswordTextField.heightAnchor.constraint(equalTo: currentPasswordTextField.heightAnchor),
            newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 15),

            updatePasswordButton.widthAnchor.constraint(equalTo: currentPasswordTextField.widthAnchor),
            updatePasswordButton.heightAnchor.constraint(equalTo: currentPasswordTextField.heightAnchor),
            updatePasswordButton.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 15),
            updatePasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        )
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default)
        alert.addAction(doneAction)
        present(alert, animated: true)
    }
}
