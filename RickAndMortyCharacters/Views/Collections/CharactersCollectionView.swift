//
//  CharactersCollectionView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

protocol CharactersCollectionViewDelegate: AnyObject {
    func showCharacter(_ character: CharacterData)
    func isLastPage() -> Bool?
    func loadMoreData(completion: @escaping () -> Void)
}

class CharactersCollectionView: UICollectionView {
    private var characters: [CharacterData]?
    private weak var ccvDelegate: CharactersCollectionViewDelegate?

    private var isLoading: Bool = false {
        didSet {
            reloadData()
        }
    }

    private var activityIndiator = UIActivityIndicatorView(style: .medium)

    init(ccvDelegate: CharactersCollectionViewDelegate) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)

        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true

        self.ccvDelegate = ccvDelegate
        delegate = self
        dataSource = self
        register(CharactersCollectionViewCell.self, forCellWithReuseIdentifier: CharactersCollectionViewCell.identifier)
        register(RefreshCharactersCollectionViewCell.self, forCellWithReuseIdentifier: RefreshCharactersCollectionViewCell.identifier)
        register(NothingFoundCharactersCollectionViewCell.self, forCellWithReuseIdentifier: NothingFoundCharactersCollectionViewCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setCharacters(_ characters: [CharacterData]) {
        self.characters = characters
        reloadData()
    }

    private func loadMoreData() {
        guard let ccvDelegate = ccvDelegate else { return }
        guard let isLastPage = ccvDelegate.isLastPage() else { return }
        guard !isLastPage else { return }
        isLoading = true

        ccvDelegate.loadMoreData {
            self.isLoading = false
        }
    }

    public func scrollToTop() {
        let topIndexPath = IndexPath(item: 0, section: 0)
        scrollToItem(at: topIndexPath, at: .top, animated: true)
    }
}

extension CharactersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let characters = characters else { return 0 }
        if characters.isEmpty {
            return 1
        }
        return characters.count + (isLoading ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // show nothing found cell
        if let characters = characters, characters.isEmpty {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NothingFoundCharactersCollectionViewCell.identifier,
                for: indexPath
            ) as! NothingFoundCharactersCollectionViewCell
            cell.configure()
            return cell
            // show refresh cell under everything if loading
        } else if isLoading && indexPath.row == (characters?.count ?? 0) {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RefreshCharactersCollectionViewCell.identifier,
                for: indexPath
            ) as! RefreshCharactersCollectionViewCell
            cell.configure()
            return cell
        } else {
            // show normal cell
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharactersCollectionViewCell.identifier,
                for: indexPath
            ) as! CharactersCollectionViewCell

            guard let previewCharacter = characters?[indexPath.row] else { return cell }
            cell.configure(with: previewCharacter)
            return cell
        }
    }
}

extension CharactersCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
        guard let character = characters?[indexPath.row] else { return }
        ccvDelegate?.showCharacter(character)
    }
}

extension CharactersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let characters = characters, characters.isEmpty {
            return CGSize(width: UIScreen.main.bounds.width, height: 480)
        }
        return CGSize(width: frame.width, height: 96)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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
