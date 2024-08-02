//
//  CharactersCollectionView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

// MARK: - CharactersCollectionViewDelegate protocol

protocol CharactersCollectionViewDelegate: AnyObject {
    func showCharacter(_ character: CharacterData)
    func isLastPage() -> Bool?
    func loadMoreData(completion: @escaping () -> Void)
}

// MARK: - CharactersCollectionView

class CharactersCollectionView: UICollectionView {
    private var characters: [CharacterData]?
    private weak var charactersCollectionViewDelegate: CharactersCollectionViewDelegate?

    private var isLoading: Bool = false {
        didSet {
            reloadData()
        }
    }

    private var activityIndiator = UIActivityIndicatorView(style: .medium)

    // MARK: - Lifecycle

    init(charactersCollectionViewDelegate: CharactersCollectionViewDelegate) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)

        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true

        self.charactersCollectionViewDelegate = charactersCollectionViewDelegate
        delegate = self
        dataSource = self
        register(CharactersCollectionViewCell.self, forCellWithReuseIdentifier: CharactersCollectionViewCell.identifier)
        register(RefreshCharactersCollectionViewCell.self,
                 forCellWithReuseIdentifier: RefreshCharactersCollectionViewCell.identifier)
        register(NothingFoundCharactersCollectionViewCell.self,
                 forCellWithReuseIdentifier: NothingFoundCharactersCollectionViewCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setCharacters(_ characters: [CharacterData]) {
        self.characters = characters
        reloadData()
    }
}

// MARK: - Additional functions

extension CharactersCollectionView {
    private func loadMoreData() {
        guard let charactersCollectionViewDelegate = charactersCollectionViewDelegate else { return }
        guard let isLastPage = charactersCollectionViewDelegate.isLastPage() else { return }
        guard !isLastPage else { return }
        isLoading = true

        charactersCollectionViewDelegate.loadMoreData {
            self.isLoading = false
        }
    }

    public func scrollToTop() {
        let topIndexPath = IndexPath(item: 0, section: 0)
        scrollToItem(at: topIndexPath, at: .top, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension CharactersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let characters = characters else { return 0 }
        if characters.isEmpty {
            return 1
        }
        return characters.count + (isLoading ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // show nothing found cell
        if let characters = characters, characters.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NothingFoundCharactersCollectionViewCell.identifier,
                for: indexPath
            ) as? NothingFoundCharactersCollectionViewCell else { return UICollectionViewCell() }
            cell.configure()
            return cell
            // show refresh cell under everything if loading
        } else if isLoading && indexPath.row == (characters?.count ?? 0) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RefreshCharactersCollectionViewCell.identifier,
                for: indexPath
            ) as? RefreshCharactersCollectionViewCell else { return UICollectionViewCell() }
            cell.configure()
            return cell
        } else {
            // show normal cell
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharactersCollectionViewCell.identifier,
                for: indexPath
            ) as? CharactersCollectionViewCell else { return UICollectionViewCell() }

            guard let previewCharacter = characters?[indexPath.row] else { return cell }
            cell.configure(with: previewCharacter)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CharactersCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
        guard let characters else { return }
        guard !characters.isEmpty else { return }
        let character = characters[indexPath.row]
        charactersCollectionViewDelegate?.showCharacter(character)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CharactersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let characters = characters, characters.isEmpty {
            return CGSize(width: frame.width, height: 260)
        }
        return CGSize(width: frame.width, height: 96)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height && !isLoading {
            loadMoreData()
        }
    }
}
