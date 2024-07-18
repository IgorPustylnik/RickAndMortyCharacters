//
//  CharactersCollectionView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

protocol CharactersCollectionViewDelegate: AnyObject {
    func showCharacter(_ character: CharacterData)
}

class CharactersCollectionView: UICollectionView {
    private var characters: [CharacterData]?
    weak private var ccvDelegate: CharactersCollectionViewDelegate?
    
    init(ccvDelegate: CharactersCollectionViewDelegate) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceVertical = true
        
        self.ccvDelegate = ccvDelegate
        self.delegate = self
        self.dataSource = self
        self.register(CharactersCollectionViewCell.self, forCellWithReuseIdentifier: CharactersCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCharacters(_ characters: [CharacterData]) {
        self.characters = characters
        reloadData()
    }

}

extension CharactersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharactersCollectionViewCell.identifier,
          for: indexPath
        ) as! CharactersCollectionViewCell
        
        guard let previewCharacter = characters?[indexPath.row] else { return cell }
        cell.configure(with: previewCharacter)
        return cell
    }
    
}

extension CharactersCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
        guard let character = characters?[indexPath.row] else { return }
        self.ccvDelegate?.showCharacter(character)
    }
}

extension CharactersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 353, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
}

