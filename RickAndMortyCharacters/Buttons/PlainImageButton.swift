//
//  PlainImageButton.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

class PlainImageButton: UIButton {
    private var imageName: String
    private var size: UIButton.Configuration.Size

    // MARK: - Activity

    private var active: Bool {
        didSet {
            updateConfig()
        }
    }

    func setActive(_ active: Bool) {
        self.active = active
    }

    func getActive() -> Bool {
        return active
    }

    // MARK: - Lifecycle

    init(imageName: String, active: Bool, size: UIButton.Configuration.Size) {
        self.active = active
        self.imageName = imageName
        self.size = size
        super.init(frame: .zero)
        updateConfig()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func updateConfig() {
        var config = UIButton.Configuration.borderless()
        config.buttonSize = size
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = active ? .Colors.aqua : .Colors.mainText

        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        config.image = UIImage(named: imageName)?
            .withTintColor(
                active ? .Colors.aqua : .Colors.mainText,
                renderingMode: .alwaysOriginal)
        config.imagePlacement = .all

        configuration = config
    }
}
