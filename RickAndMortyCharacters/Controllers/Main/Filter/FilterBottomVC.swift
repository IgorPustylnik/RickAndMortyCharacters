//
//  FilterView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

protocol FilterOutputDelegate: AnyObject {
    func applyFilter(_ filter: Filter)
    func refreshFilterOnView()
}

protocol FilterInputDelegate: AnyObject {
    func resfreshFilterOnView(filter: Filter)
}

class FilterBottomVC: UIViewController {
        
    private let presenter = FilterPresenter()
    weak private var outputDelegate: FilterOutputDelegate?
    
    private lazy var bottomView = FilterBottomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setInputDelegate(mainInputDelegate: self)
        outputDelegate = presenter
        bottomView.setDelegate(self)
        outputDelegate?.refreshFilterOnView()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .Colors.secondaryBackground
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: view.topAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}

extension FilterBottomVC: FilterInputDelegate {
    func resfreshFilterOnView(filter: Filter) {
        bottomView.setFilter(filter)
    }
    
}

extension FilterBottomVC: FilterBottomViewDelegate {
    
    func pressedApplyFilter(with filter: Filter) {
        outputDelegate?.applyFilter(filter)
        dismiss(animated: true)
    }
    
    func pressedClose() {
        dismiss(animated: true)
    }
    
}
