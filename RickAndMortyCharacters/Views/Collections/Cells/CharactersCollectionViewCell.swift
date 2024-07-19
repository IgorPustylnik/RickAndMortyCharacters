//
//  CharactersCollectionViewCell.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

class CharactersCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharactersCollectionViewCell"

    // MARK: - UI Elements

    private lazy var hStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .leading
        
        $0.addArrangedSubview(spinner)
        $0.addArrangedSubview(imageView)
        $0.addArrangedSubview(labelsStackView)

        return $0
    }(UIStackView())
    
    private var image: UIImage? {
        didSet {
            if let image {
                spinner.stopAnimating()
                spinner.isHidden = true
                imageView.isHidden = false
            }
        }
    }

    private lazy var imageView: UIImageView = {
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true

        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: 84),
            $0.heightAnchor.constraint(equalToConstant: 64),
        ])
        return $0
    }(UIImageView())

    private lazy var spinner: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hidesWhenStopped = true
        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: 84),
            $0.heightAnchor.constraint(equalToConstant: 64),
        ])
        return $0
    }(UIActivityIndicatorView(style: .medium))

    private lazy var labelsStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 6
        $0.addArrangedSubview(nameLabel)
        $0.addArrangedSubview(statusAndSpeciesLabel)
        $0.addArrangedSubview(genderLabel)
        return $0
    }(UIStackView())

    private lazy var nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.IBMPlexSans.medium(size: 18)
        $0.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return $0
    }(UILabel())

    private lazy var statusAndSpeciesLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.IBMPlexSans.semiBold(size: 12)
        $0.textColor = .Colors.mainText
        $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return $0
    }(UILabel())

    private lazy var genderLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.IBMPlexSans.regular(size: 12)
        $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return $0
    }(UILabel())

    // MARK: - Configuration

    public func configure(with character: CharacterData) {
        if let image = character.image {
            imageView.image = image
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
            spinner.startAnimating()
        }
        nameLabel.text = character.name
        statusAndSpeciesLabel.attributedText = createColoredString(
            status: character.status,
            species: character.species)
        genderLabel.text = character.gender == .unknown ? "Unknown" : character.gender.rawValue
        setupLayout()
    }

    private func setupLayout() {
        backgroundColor = UIColor.Colors.secondaryBackground
        layer.cornerRadius = 24

        addSubview(hStackView)

        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 18),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusAndSpeciesLabel.text = nil
        genderLabel.text = nil
    }
}

// MARK: - Additional methods

extension CharactersCollectionViewCell {
    private func createColoredString(status: Status, species: String) -> NSAttributedString {
        let statusString = status == .unknown ? "Unknown" : status.rawValue
        let text = "\(statusString) • \(species)"
        let string = NSMutableAttributedString(string: text)
        let statusRange = (text as NSString).range(of: statusString)

        var color: CGColor
        switch status {
        case .alive:
            color = UIColor.Colors.green.cgColor
        case .dead:
            color = UIColor.Colors.red.cgColor
        case .unknown:
            color = UIColor.Colors.gray.cgColor
        }

        string.addAttribute(.foregroundColor, value: color, range: statusRange)
        return string
    }
}
