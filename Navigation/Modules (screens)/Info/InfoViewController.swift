//
//  InfoViewController.swift
//  Navigation
//
//  Created by Anton Kruglov on 04.08.2026.
//

import UIKit

class InfoViewController: UIViewController {
    var residentNames: [String] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

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
        tuneTableView()
        setupConstraints()
        fetchData()
        fetchPlanetData()
    }

    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }
        CodableNetworkService.fetchData(from: url) { result in
            switch result {
            case let .success(data):
                let parser = Parser()
                if let user = parser.parse(data: data) {
                    DispatchQueue.main.async {
                        self.titleLabel.text = user.title
                    }
                }
            case let .failure(error):
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func fetchPlanetData() {
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else { return }
        let decoder = JSONDecoder()

        CodableNetworkService.fetchData(from: url) { result in
            switch result {
            case let .success(data):
                if let planet = try? decoder.decode(JsonPlanet.self, from: data) {
                    DispatchQueue.main.async {
                        self.planetLabel.text = "Orbtal period: \(planet.orbitalPeriod)"
                        self.residentNames.removeAll()
                    }

                    let group = DispatchGroup()
                    for residentUrl in planet.residents {
                        group.enter()
                        guard let url = URL(string: residentUrl) else {
                            group.leave()
                            continue
                        }
                        CodableNetworkService.fetchData(from: url) { result in
                            switch result {
                            case let .success(data):
                                if let resident = try? decoder.decode(JsonResidentName.self, from: data) {
                                    DispatchQueue.main.async {
                                        self.residentNames.append(resident.name)
                                    }
                                }
                            case let .failure(error):
                                print(error.localizedDescription)
                            }
                            group.leave()
                        }
                    }

                    group.notify(queue: .main) {
                        self.tableView.reloadData()
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    func setupView() {
        view.backgroundColor = .cyan
        title = "Information"
    }

    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(infoButton)
        view.addSubview(titleLabel)
        view.addSubview(planetLabel)
    }

    func tuneTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.register(ResidentTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func infoButtonPressed() {
        showAlert()
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            tableView.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: -15),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),

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

extension InfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residentNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let nameCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ResidentTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        nameCell.configure(with: residentNames[indexPath.row])
        return nameCell
    }
}

extension InfoViewController: UITableViewDelegate {}
