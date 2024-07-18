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
    func setFilterState(filter: Filter)
    func getFilterState() -> Filter
    func refreshCharactersList()
    func loadMoreCharacters()
}

class MainVC: UIViewController {
    
    private let presenter = MainPresenter()
    weak private var outputDelegate: MainOutputDelegate?
    
    private lazy var charactersCollectionView = CharactersCollectionView(ccvDelegate: self)
    private var tapBottomSheetHider: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        outputDelegate = presenter
        presenter.setInputDelegate(mainInputDelegate: self)
        
        outputDelegate?.refreshCharactersList()
        
        addHidingSheetGestureRecognizer()
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .Colors.background
        
        navigationItem.title = "Rick & Morty Characters"
        navigationItem.backButtonTitle = ""
        
        charactersCollectionView.contentInset.top = 15
        
        view.addSubview(charactersCollectionView)
        
        // FIXME: - TESTING AREA
        let button = FilterToggleButton(title: "Test", isOn: false)
        button.addTarget(self, action: #selector(showFiltersSheet), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            charactersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            charactersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            charactersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            charactersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc
    private func showFiltersSheet() {
        guard let filter = outputDelegate?.getFilterState() else { return }
        let viewControllerToPresent = FilterBottomVC(filter: filter)
        viewControllerToPresent.setOutputDelegate(outputDelegate: self)
        
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
    
    private func addHidingSheetGestureRecognizer() {
        tapBottomSheetHider = UITapGestureRecognizer(target: self, action: #selector(hideBottomSheet))
        guard let tapBottomSheetHider else { return }
        view.addGestureRecognizer(tapBottomSheetHider)
        tapBottomSheetHider.cancelsTouchesInView = false
    }
    
    @objc
    private func hideBottomSheet() {
        tapBottomSheetHider?.cancelsTouchesInView = false
        dismiss(animated: true)
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

extension MainVC: FilterOutputDelegate {
    func applyFilter(_ filter: Filter) {
        outputDelegate?.setFilterState(filter: filter)
        hideBottomSheet()
    }
    
    func closeFilter() {
        hideBottomSheet()
    }
    
}
