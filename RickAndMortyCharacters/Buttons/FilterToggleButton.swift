//
//  FilterToggleButton.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

class FilterToggleButton: UIButton {
    private var title: String
    private var toggleAction: (() -> Void)?

    // MARK: - Activity

    private var isActive: Bool {
        didSet {
            updateConfig()
        }
    }

    func getActive() -> Bool {
        return isActive
    }

    func setActive(_ active: Bool) {
        isActive = active
    }

    // MARK: - Lifecycle

    init(title: String, isOn: Bool, toggleAction: (() -> Void)?) {
        self.title = title
        self.isActive = isOn
        self.toggleAction = toggleAction
        super.init(frame: .zero)
        addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        updateConfig()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func updateConfig() {
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = isActive ? .Colors.filterSelected : .clear
        config.baseForegroundColor = isActive ? .Colors.background : .Colors.filterSelected
        config.title = title
        config.background.cornerRadius = 24
        config.background.strokeWidth = isActive ? 0 : 2
        config.background.strokeColor = .Colors.border
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)

        //        if isOn {
        //            let image = UIImage(named: "icons/checkMark")?
        //                .withTintColor(
        //                    .Colors.background,
        //                    renderingMode: .alwaysOriginal)
        //            config.image = image
        //            config.imagePadding = 8
        //            config.imagePlacement = .trailing
        //        } else {
        //            config.image = nil
        //        }
        config.attributedTitle = AttributedString(title,
                                                  attributes: AttributeContainer([
                                                      .font: UIFont.IBMPlexSans.regular(size: 12)
                                                  ]))

        configuration = config
    }
}

// MARK: - Selectors

extension FilterToggleButton {
    @objc
    private func toggleButtonTapped() {
        isActive.toggle()
        toggleAction?()
    }
}
