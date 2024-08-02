//
//  FilterView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

// MARK: - FilterOutputDelegate protocol

protocol FilterOutputDelegate: AnyObject {
    func applyFilter(_ filter: Filter)
    func refreshFilterOnView()
}

// MARK: - FilterInputDelegate protocol

protocol FilterInputDelegate: AnyObject {
    func resfreshFilterOnView(filter: Filter)
}

// MARK: - FilterBottomVC

class FilterBottomVC: UIViewController {
    private let presenter = FilterPresenter()
    private weak var outputDelegate: FilterOutputDelegate?

    private lazy var bottomView = FilterBottomView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setInputDelegate(mainInputDelegate: self)
        outputDelegate = presenter
        bottomView.setDelegate(self)
        outputDelegate?.refreshFilterOnView()
        setupLayout()
    }

    // MARK: - Layout setup

    private func setupLayout() {
        view.backgroundColor = .Colors.secondaryBackground
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: view.topAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - FilterInputDelegate

extension FilterBottomVC: FilterInputDelegate {
    func resfreshFilterOnView(filter: Filter) {
        bottomView.setFilter(filter)
    }
}

// MARK: - FilterBottomViewDelegate

extension FilterBottomVC: FilterBottomViewDelegate {
    func pressedApplyFilter(with filter: Filter) {
        outputDelegate?.applyFilter(filter)
        dismiss(animated: true)
    }

    func pressedClose() {
        dismiss(animated: true)
    }
}
