//
//  InfoViewController.swift
//  Navigation
//
//  Created by Anton Kruglov on 04.08.2026.
//

import UIKit

class InfoViewController: UIViewController {

    private lazy var infoButton: CustomButton = {
        let infoButton = CustomButton(title: "Hi! This is a new screen.", titleColor: .white)
        infoButton.layer.cornerRadius = 20
        guard let bluePixel = UIImage(named: "bluePixel") else {
            return infoButton
        }
        let dimmedBluePixel = imageWithAlpha(bluePixel, alpha: 0.8)
        infoButton.setBackgroundImage(bluePixel, for: .normal)
        infoButton.setBackgroundImage(dimmedBluePixel, for: .highlighted)
        infoButton.setBackgroundImage(dimmedBluePixel, for: .selected)
        infoButton.setBackgroundImage(dimmedBluePixel, for: .disabled)

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

    private lazy var planetLabel: UILabel = {
        let planetLabel = UILabel()
        planetLabel.translatesAutoresizingMaskIntoConstraints = false
        planetLabel.clipsToBounds = true
        planetLabel.backgroundColor = .vk
        planetLabel.layer.cornerRadius = 30
        planetLabel.textColor = .white
        planetLabel.font = .systemFont(ofSize: 17, weight: .bold)
        planetLabel.textAlignment = .center

        return planetLabel
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
        view.addSubview(planetLabel)
    }

    @objc private func infoButtonPressed() {
        showAlert()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 220),
            infoButton.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),

            planetLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            planetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetLabel.widthAnchor.constraint(equalToConstant: 300),
            planetLabel.heightAnchor.constraint(equalToConstant: 100),
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

    private func imageWithAlpha(_ image: UIImage, alpha: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)

        return renderer.image { _ in image.draw(at: .zero, blendMode: .normal, alpha: alpha)
        }
    }
}
