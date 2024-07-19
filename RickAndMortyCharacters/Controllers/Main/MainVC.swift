//
//  ViewController.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

protocol MainInputDelegate: AnyObject {
    func refreshCharactersView(_ characters: [CharacterData])
    func refreshFiltersView(with filter: Filter)
}

protocol MainOutputDelegate: AnyObject {
    func resetFilterState()
    func refreshCharactersList()
    func setSearchQuery(_ query: String)
    func loadCharacters(completion: @escaping () -> Void)
    func isLastPage() -> Bool?
}

class MainVC: UIViewController {
    
    private let presenter = MainPresenter()
    weak private var outputDelegate: MainOutputDelegate?
    
    private lazy var filterSearchView = FilterSearchView(delegate: self)
    private lazy var charactersCollectionView = CharactersCollectionView(ccvDelegate: self)
    private var tapBottomSheetHider: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        outputDelegate = presenter
        presenter.setInputDelegate(mainInputDelegate: self)
        
        addDismissAllOverlayingComponentsGestureRecognizer()
        
        setupLayout()
    }
    
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
    
    private func addDismissAllOverlayingComponentsGestureRecognizer() {
        tapBottomSheetHider = UITapGestureRecognizer(target: self, action: #selector(dismissAllOverlays))
        guard let tapBottomSheetHider else { return }
        view.addGestureRecognizer(tapBottomSheetHider)
        tapBottomSheetHider.cancelsTouchesInView = false
    }
    
    @objc
    private func dismissAllOverlays() {
        tapBottomSheetHider?.cancelsTouchesInView = false
        view.endEditing(true)
        dismiss(animated: true)
    }

}

extension MainVC: MainInputDelegate {
    
    func refreshCharactersView(_ characters: [CharacterData]) {
        charactersCollectionView.setCharacters(characters)
    }
    
    func refreshFiltersView(with filter: Filter) {
        filterSearchView.setFilter(filter: filter)
    }
}

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
