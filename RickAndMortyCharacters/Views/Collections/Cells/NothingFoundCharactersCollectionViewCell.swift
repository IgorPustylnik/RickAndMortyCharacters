//
//  NothingFoundCharactersCollectionViewCell.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 19.07.2024.
//

import UIKit

class NothingFoundCharactersCollectionViewCell: UICollectionViewCell {
    static let identifier = "NothingFoundCharactersCollectionViewCell"

    // MARK: - UI Elements

    private lazy var nothingFoundImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.image = UIImage(named: "images/nothingFound")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            $0.heightAnchor.constraint(equalToConstant: 200),
            $0.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        return $0
    }(UIImageView())
    
    private lazy var hView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .Colors.secondaryBackground
        $0.layer.cornerRadius = 32
        
        $0.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.centerYAnchor.constraint(equalTo: $0.centerYAnchor),
            vStackView.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: -46)
        ])
        
        return $0
    }(UIView())
    
    private lazy var vStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10
        
        $0.addArrangedSubview(topLabel)
        $0.addArrangedSubview(bottomLabel)
        
        return $0
    }(UIStackView())
    
    private lazy var topLabel: UILabel = {
        $0.font = .IBMPlexSans.medium(size: 20)
        $0.textColor = .Colors.mainText
        $0.text = "No matches found"
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    
    private lazy var bottomLabel: UILabel = {
        $0.font = .IBMPlexSans.regular(size: 12)
        $0.textColor = .Colors.secondaryText
        $0.text = "Please try another filters"
        $0.textAlignment = .center
        
        return $0
    }(UILabel())

    // MARK: - Configuration

    public func configure() {
        setupLayout()
    }

    private func setupLayout() {

        addSubview(nothingFoundImageView)
        addSubview(hView)

        NSLayoutConstraint.activate([
            nothingFoundImageView.topAnchor.constraint(equalTo: topAnchor),
            nothingFoundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            hView.topAnchor.constraint(equalTo: nothingFoundImageView.bottomAnchor, constant: -332),
            hView.heightAnchor.constraint(equalToConstant: 332),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

