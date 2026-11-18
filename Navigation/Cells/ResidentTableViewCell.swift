//
//  ResidentTableViewCell.swift
//  Navigation
//
//  Created by Anton Kruglov on 16.11.2026.
//

import Foundation
import UIKit

class ResidentTableViewCell: UITableViewCell {
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        tuneView()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        isHidden = false
        isSelected = false
        isHighlighted = false
    }

    private lazy var residentNameLabel: UILabel = {
        let residentNameLabel = UILabel()
        residentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        residentNameLabel.backgroundColor = .clear
        residentNameLabel.textColor = .black
        residentNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        return residentNameLabel
    }()

    func addSubviews() {
        contentView.addSubview(residentNameLabel)
    }

    func tuneView() {
        contentView.clipsToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        accessoryType = .none
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            residentNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            residentNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
        ])
    }

    func configure(with name: String) {
        residentNameLabel.text = name
    }
}
