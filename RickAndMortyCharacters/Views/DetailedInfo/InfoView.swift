//
//  InfoView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

class InfoView: UIView {
    private var character: CharacterData?

    // MARK: - UI Elements

    // MARK: - Main stack

    private lazy var mainVStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill

        $0.addArrangedSubview(topVStack)
        $0.addArrangedSubview(bottomVStack)

        return $0
    }(UIStackView())

    // MARK: - Top stack

    private lazy var topVStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill

        $0.addArrangedSubview(imageView)
        $0.addArrangedSubview(statusView)

        NSLayoutConstraint.activate([
            statusView.heightAnchor.constraint(equalToConstant: 41.92),
            statusView.leadingAnchor.constraint(equalTo: $0.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: $0.trailingAnchor),

            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)
        ])
        return $0
    }(UIStackView())

    private lazy var imageView: UIImageView = {
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true

        $0.heightAnchor.constraint(equalToConstant: 317).isActive = true

        return $0
    }(UIImageView())

    private lazy var statusView: UIView = {
        $0.layer.cornerRadius = 16

        $0.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: $0.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: $0.centerYAnchor)
        ])

        return $0
    }(UIView())

    private lazy var statusLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.IBMPlexSans.semiBold(size: 16)
        $0.textColor = .Colors.onColoredBackgroundText
        return $0
    }(UILabel())

    // MARK: - Bottom stack
    private lazy var bottomVStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .leading

        return $0
    }(UIStackView())

    private func createLabel(title: String, info: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.IBMPlexSans.regular(size: 16)
        label.textColor = .Colors.mainText
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byClipping

        let text = "\(title): \(info)"
        let string = NSMutableAttributedString(string: text)

        let titleRange = (text as NSString).range(of: title + ":")

        let semiBoldFont = UIFont.IBMPlexSans.semiBold(size: 16)
        string.addAttribute(.font, value: semiBoldFont, range: titleRange)
        label.attributedText = string

        return label
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with character: CharacterData) {
        self.character = character

        setupInfo()
        setupLayout()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 24
        backgroundColor = .Colors.secondaryBackground

        addSubview(mainVStack)

        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Character info setup

    private func setupInfo() {
        guard let character else { return }

        // Set image
        if let image = character.image {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle.badge.questionmark.fill")
        }

        // Set status
        statusLabel.text = character.status == .unknown ? "Unknown" : character.status.rawValue
        switch character.status {
        case .alive:
            statusView.backgroundColor = .Colors.green
        case .dead:
            statusView.backgroundColor = .Colors.red
        case .unknown:
            statusView.backgroundColor = .Colors.gray
        }

        // Set other info
        var episodes = ""
        if !character.episodes.isEmpty {
            character.episodes.forEach {
                episodes.append($0 + ", ")
            }
            episodes.removeLast(2)
        } else {
            episodes.append("None")
        }

        bottomVStack.addArrangedSubview(createLabel(title: "Species",
                                                    info: character.species))
        bottomVStack.addArrangedSubview(createLabel(title: "Gender",
                                                    info: character.gender == .unknown ?
                                                        "Unknown" : character.gender.rawValue))
        bottomVStack.addArrangedSubview(createLabel(title: "Episodes",
                                                    info: episodes))
        bottomVStack.addArrangedSubview(createLabel(title: "Last known location",
                                                    info: character.location))
    }
}
