//
//  MainViewController.swift
//  DocApp
//
//  Created by Anton Kruglov on 26.11.2026.
//

import UIKit

class LoginViewController: UIViewController {
    private lazy var loginTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.borderStyle = .roundedRect
        loginTextField.placeholder = "Login"
        loginTextField.textColor = .black
        loginTextField.backgroundColor = .systemGray4

        return loginTextField
    }()

    private lazy var passwordTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.borderStyle = .roundedRect
        loginTextField.placeholder = "Password"
        loginTextField.textColor = .black
        loginTextField.backgroundColor = .systemGray4

        return loginTextField
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
        // Do any additional setup after loading the view.
    }

    @objc func loginButtonTapped() {
        let tableVc = MainTableViewController()
        navigationController?.pushViewController(tableVc, animated: true)
    }

    func setupView() {
        view.backgroundColor = .systemGray5
    }

    func addSubviews() {
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            loginTextField.widthAnchor.constraint(equalToConstant: 200),
            loginTextField.heightAnchor.constraint(equalToConstant: 40),
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            passwordTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 15),

            loginButton.widthAnchor.constraint(equalTo: loginTextField.widthAnchor),
            loginButton.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        )
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
