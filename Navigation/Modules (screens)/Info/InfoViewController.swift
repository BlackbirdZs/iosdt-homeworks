//
//  InfoViewController.swift
//  Navigation
//
//  Created by Anton Kruglov on 04.08.2026.
//

import UIKit

class InfoViewController: UIViewController {
    private lazy var infoButton: CustomButton = {
        let infoButton = CustomButton(title: "Hi! This is a new screen.", titleColor: .systemBlue)

        infoButton.tapOnButton = { [weak self] in self?.infoButtonPressed() }

        return infoButton
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.clipsToBounds = true
        titleLabel.backgroundColor = .vk
        titleLabel.layer.cornerRadius = 30
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textAlignment = .center

        return titleLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addSubviews()
        setupConstraints()
        fetchData()
    }

    func fetchData() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        CodableNetworkService.fetchData(from: url) { result in
            switch result {
            case let .success(data):
                let parcer = Parcer()
                if let user = parcer.parce(data: data) {
                    DispatchQueue.main.async {
                        self.titleLabel.text = user.title
                    }
                }
            case let .failure(error):
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func setupView() {
        view.backgroundColor = .cyan
        title = "Information"
    }

    func addSubviews() {
        view.addSubview(infoButton)
        view.addSubview(titleLabel)
    }

    @objc private func infoButtonPressed() {
        showAlert()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "Buttons are tappable!",
            message: "Some of the buttons below will be tapped.",
            preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: "Done",
                                          style: .default) { _ in
            print("User has tapped the Done button.")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("User has tapped the Cancel button.")
        }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
