//
//  NoInternetVC.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 19.07.2024.
//

import UIKit

class NetworkErrorVC: UIViewController {
    private var networkMonitor = NetworkMonitor.shared

    // MARK: - UI Elements

    private lazy var imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "images/networkError")

        NSLayoutConstraint.activate([
            $0.heightAnchor.constraint(equalToConstant: 263),
            $0.widthAnchor.constraint(equalToConstant: 263)
        ])

        return $0
    }(UIImageView())

    private lazy var topLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .IBMPlexSans.semiBold(size: 28)
        $0.textColor = .Colors.mainText
        $0.textAlignment = .center
        $0.text = "Network Error"
        return $0
    }(UILabel())

    private lazy var bottomLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .IBMPlexSans.regular(size: 16)
        $0.textColor = .Colors.secondaryText
        $0.textAlignment = .center
        $0.text = "There was an error connecting.\nPlease check your internet."
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var retryButton = CustomAquaButton(title: "Retry")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        view.backgroundColor = .Colors.background

        view.addSubview(imageView)
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        view.addSubview(retryButton)

        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.addTarget(self, action: #selector(retryButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: -294),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 14),
            bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            retryButton.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 32),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.56),
            retryButton.heightAnchor.constraint(equalToConstant: 42)

        ])
    }
}

// MARK: - Selectors

extension NetworkErrorVC {
    @objc
    private func retryButtonPressed() {
        // here is supposed to be manual retry logic but at this point the main screen presents itself automatically
    }
}
