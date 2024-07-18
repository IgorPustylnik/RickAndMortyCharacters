//
//  FilterToggleButton.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

class FilterToggleButton: UIButton {
    
    private var title: String
    
    private var isOn: Bool {
            didSet {
                updateConfig()
            }
        }
    
    private func updateConfig() {
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = isOn ? .Colors.filterSelected : .clear
        config.baseForegroundColor = isOn ? .Colors.background : .Colors.filterSelected
        config.title = title
        config.background.cornerRadius = 24
        config.background.strokeWidth = isOn ? 0 : 2
        config.background.strokeColor = .Colors.border
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        
        if isOn {
            let image = UIImage(named: "icons/checkMark")?.withTintColor(.Colors.background, renderingMode: .alwaysOriginal)
            config.image = image
            config.imagePadding = 8
            config.imagePlacement = .trailing
        } else {
            config.image = nil
        }
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: UIFont.IBMPlexSans.regular(size: 12)]))
        
        self.configuration = config
    }
    
    init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        updateConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggleButtonTapped() {
        isOn.toggle()
    }
    
    func setActive(_ active: Bool) {
        self.isOn = active
    }
    
    func getButtonState() -> Bool {
        return isOn
    }

}
