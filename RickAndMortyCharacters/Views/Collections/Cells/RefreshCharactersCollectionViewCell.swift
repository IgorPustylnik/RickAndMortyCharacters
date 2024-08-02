//
//  RefreshCharactersCollectionViewCell.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 19.07.2024.
//

import UIKit

class RefreshCharactersCollectionViewCell: UICollectionViewCell {
    static let identifier = "RefreshCharactersCollectionViewCell"

    // MARK: - UI Elements

    private lazy var spinner: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .medium
        return $0
    }(UIActivityIndicatorView())

    // MARK: - Configuration

    public func configure() {
        setupLayout()
        spinner.startAnimating()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
