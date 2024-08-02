//
//  DetailedInfoVC.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

class DetailedInfoVC: UIViewController {
    private var character: CharacterData?

    // MARK: - UI Elements

    private lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = false

        $0.addSubview(contentView)

        return $0
    }(UIScrollView())

    private lazy var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.addSubview(infoView)

        return $0
    }(UIView())

    private lazy var infoView = InfoView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // make it so that the swipe back gesture works (with the extension's realization of the delegate)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setupCustomBackButton()
        setupLayout()
    }

    public func setCharacter(_ character: CharacterData) {
        navigationItem.title = character.name
        infoView.configure(with: character)
        infoView.layoutSubviews()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        view.backgroundColor = .Colors.background

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            infoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        // Bind scrollView's height
        let hConst = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        hConst.isActive = true
        hConst.priority = UILayoutPriority(50)
    }
}
