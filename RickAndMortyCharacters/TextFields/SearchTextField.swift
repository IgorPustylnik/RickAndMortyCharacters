//
//  SearchTextField.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

class SearchTextField: UITextField {

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        placeholder = "Search"
        autocorrectionType = .no
        autocapitalizationType = .none
        backgroundColor = .Colors.background
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.Colors.border.cgColor
        
        let imageView = UIImageView(frame: CGRect(x: 13, y: 13, width: 16.68, height: 16))
        let image = UIImage(named: "icons/search")?.withTintColor(.Colors.secondaryText, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 36.68, height: 40))
        imageContainerView.addSubview(imageView)
        
        leftView = imageContainerView
        leftViewMode = .always
    }
}
