//
//  FilterOverviewButton.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

class FilterOverviewButton: UIButton {
    private var title: String
    private var clickable: Bool

    // MARK: - Lifecycle

    init(title: String, clickable: Bool) {
        self.title = title
        self.clickable = clickable
        super.init(frame: .zero)
        updateConfig()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func updateConfig() {
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .small
        config.baseBackgroundColor = clickable ? .Colors.aqua : .Colors.filterSelected
        config.baseForegroundColor = clickable ? .Colors.onColoredBackgroundText : .Colors.background

        config.title = title
        config.background.cornerRadius = 16.85
        config.contentInsets = NSDirectionalEdgeInsets(top: 6.5, leading: 16, bottom: 6.5, trailing: 16)
        config.attributedTitle = AttributedString(title,
                                                  attributes: AttributeContainer([
                                                      .font: UIFont.IBMPlexSans.regular(size: 8.43)
                                                  ]))

        configuration = config
    }
}
