//
//  ViewController.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

// MARK: - MainInputDelegate protocol

protocol MainInputDelegate: AnyObject {
    func refreshCharactersView(_ characters: [CharacterData])
    func refreshFiltersView(with filter: Filter)
}

// MARK: - MainOutputDelegate protocol

protocol MainOutputDelegate: AnyObject {
    func resetFilterState()
    func refreshCharactersList()
    func setSearchQuery(_ query: String)
    func loadCharacters(completion: @escaping () -> Void)
    func isLastPage() -> Bool?
}

// MARK: - MainVC

class MainVC: UIViewController {
    private let presenter = MainPresenter()
    private weak var outputDelegate: MainOutputDelegate?

    private lazy var filterSearchView = FilterSearchView(delegate: self)
    private lazy var charactersCollectionView = CharactersCollectionView(charactersCollectionViewDelegate: self)
    private var tapBottomSheetHider: UITapGestureRecognizer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        outputDelegate = presenter
        presenter.setInputDelegate(mainInputDelegate: self)

        addDismissAllOverlayingComponentsGestureRecognizer()

        setupLayout()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        view.backgroundColor = .Colors.background

        navigationItem.title = "Rick & Morty Characters"
        navigationItem.backButtonTitle = ""

        view.addSubview(charactersCollectionView)
        view.addSubview(filterSearchView)

        NSLayoutConstraint.activate([
            filterSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterSearchView.heightAnchor.constraint(equalToConstant: 72),
            filterSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            charactersCollectionView.topAnchor.constraint(equalTo: filterSearchView.bottomAnchor, constant: 24),
            charactersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            charactersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            charactersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Gesture recognizer

extension MainVC {
    private func addDismissAllOverlayingComponentsGestureRecognizer() {
        tapBottomSheetHider = UITapGestureRecognizer(target: self, action: #selector(dismissAllOverlays))
        guard let tapBottomSheetHider else { return }
        view.addGestureRecognizer(tapBottomSheetHider)
        tapBottomSheetHider.cancelsTouchesInView = false
    }
}

// MARK: - Selectors

extension MainVC {
    @objc
    private func showFiltersSheet() {
        let viewControllerToPresent = FilterBottomVC()

        tapBottomSheetHider?.cancelsTouchesInView = true

        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.preferredCornerRadius = 32

            // kostyli (sorry)
            sheet.detents = [.custom(resolver: { _ in
                311
            })]

            sheet.largestUndimmedDetentIdentifier = .none
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }

    @objc
    private func dismissAllOverlays() {
        tapBottomSheetHider?.cancelsTouchesInView = false
        view.endEditing(true)
        dismiss(animated: true)
    }
}

// MARK: - MainInputDelegate

extension MainVC: MainInputDelegate {
    func refreshCharactersView(_ characters: [CharacterData]) {
        charactersCollectionView.setCharacters(characters)
    }

    func refreshFiltersView(with filter: Filter) {
        filterSearchView.setFilter(filter: filter)
    }
}

// MARK: - FilterSearchViewDelegate

extension MainVC: FilterSearchViewDelegate {
    func pressedFiltersButton() {
        showFiltersSheet()
    }

    func pressedResetButton() {
        outputDelegate?.resetFilterState()
        charactersCollectionView.scrollToTop()
    }

    func searchTextFieldDidChange(text: String) {
        outputDelegate?.setSearchQuery(text)
    }
}

// MARK: - CharactersCollectionViewDelegate

extension MainVC: CharactersCollectionViewDelegate {
    func showCharacter(_ character: CharacterData) {
        let detailedInfoVC = DetailedInfoVC()
        detailedInfoVC.setCharacter(character)
        navigationController?.pushViewController(detailedInfoVC, animated: true)
    }

    func isLastPage() -> Bool? {
        outputDelegate?.isLastPage()
    }

    func loadMoreData(completion: @escaping () -> Void) {
        outputDelegate?.loadCharacters {
            completion()
        }
    }
}
