//
//  ViewController.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

protocol MainInputDelegate: AnyObject {
    func setCharacters(_ characters: [CharacterData])
}

protocol MainOutputDelegate: AnyObject {
    func refreshCharactersList()
    func loadMoreCharacters()
}

class MainVC: UIViewController {
    
    private let presenter = MainPresenter()
    weak private var outputDelegate: MainOutputDelegate?
    
    private lazy var charactersCollectionView = CharactersCollectionView(ccvDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        outputDelegate = presenter
        presenter.setInputDelegate(mainInputDelegate: self)
        
        outputDelegate?.refreshCharactersList()
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .Colors.background
        
        navigationItem.title = "Rick & Morty Characters"
        navigationItem.backButtonTitle = ""
        
        charactersCollectionView.contentInset.top = 15
        
        view.addSubview(charactersCollectionView)
        
        NSLayoutConstraint.activate([
            charactersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            charactersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            charactersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}

extension MainVC: MainInputDelegate {
    func setCharacters(_ characters: [CharacterData]) {
        charactersCollectionView.setCharacters(characters)
    }
    
}

extension MainVC: CharactersCollectionViewDelegate {
    func showCharacter(_ character: CharacterData) {
        let detailedInfoVC = DetailedInfoVC()
        detailedInfoVC.setCharacter(character)
        navigationController?.pushViewController(detailedInfoVC, animated: true)
    }
    
}
