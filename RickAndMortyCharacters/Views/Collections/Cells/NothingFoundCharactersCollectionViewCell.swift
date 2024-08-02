//
//  NothingFoundCharactersCollectionViewCell.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 19.07.2024.
//

import UIKit

class NothingFoundCharactersCollectionViewCell: UICollectionViewCell {
    static let identifier = "NothingFoundCharactersCollectionViewCell"

    // MARK: - UI Elements

    private lazy var nothingFoundImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.image = UIImage(named: "images/nothingFound")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true

        NSLayoutConstraint.activate([
            $0.heightAnchor.constraint(equalToConstant: 261),
            $0.widthAnchor.constraint(equalToConstant: 261)
        ])

        return $0
    }(UIImageView())

    // Gray rectangular background
    private lazy var hView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .Colors.secondaryBackground
        $0.layer.cornerRadius = 32

        $0.addSubview(labelsVStackView)

        NSLayoutConstraint.activate([
            labelsVStackView.centerYAnchor.constraint(equalTo: $0.centerYAnchor),
            labelsVStackView.trailingAnchor.constraint(equalTo: $0.trailingAnchor, constant: -46)
        ])

        return $0
    }(UIView())

    // MARK: - Labels VStack

    private lazy var labelsVStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10

        $0.addArrangedSubview(topLabel)
        $0.addArrangedSubview(bottomLabel)

        return $0
    }(UIStackView())

    private lazy var topLabel: UILabel = {
        $0.font = .IBMPlexSans.medium(size: 20)
        $0.textColor = .Colors.mainText
        $0.text = "No matches found"
        $0.textAlignment = .center

        return $0
    }(UILabel())

    private lazy var bottomLabel: UILabel = {
        $0.font = .IBMPlexSans.regular(size: 12)
        $0.textColor = .Colors.secondaryText
        $0.text = "Please try another filters"
        $0.textAlignment = .center

        return $0
    }(UILabel())

    // MARK: - Configuration

    public func configure() {
        setupLayout()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        addSubview(hView)
        addSubview(nothingFoundImageView)

        NSLayoutConstraint.activate([
            nothingFoundImageView.topAnchor.constraint(equalTo: topAnchor),
            nothingFoundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -20),

            hView.topAnchor.constraint(equalTo: nothingFoundImageView.bottomAnchor, constant: -107),
            hView.heightAnchor.constraint(equalToConstant: 107),
            hView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
