//
//  CustomAquaButton.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

class CustomAquaButton: UIButton {
    // MARK: - Lifecycle

    init(title: String) {
        super.init(frame: .zero)
        configure(with: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configure(with title: String) {
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = .Colors.aqua
        config.baseForegroundColor = .Colors.onColoredBackgroundText
        config.title = title
        config.background.cornerRadius = 16
        config.titlePadding = 10
        config.attributedTitle = AttributedString(title,
                                                  attributes: AttributeContainer([
                                                      .font: UIFont.IBMPlexSans.medium(size: 18)
                                                  ]))

        configuration = config
    }
}
