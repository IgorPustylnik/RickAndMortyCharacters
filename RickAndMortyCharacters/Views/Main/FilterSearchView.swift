//
//  FilterSearchView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

// MARK: - FilterSearchViewDelegate protocol

protocol FilterSearchViewDelegate: AnyObject {
    func pressedFiltersButton()
    func pressedResetButton()
    func searchTextFieldDidChange(text: String)
}

// MARK: - FilterSearchView

class FilterSearchView: UIView {
    private var filter: Filter?

    private weak var delegate: FilterSearchViewDelegate?

    // MARK: - UI Elements

    private lazy var mainVStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fill
        $0.alignment = .fill

        $0.addArrangedSubview(searchBarView)
        $0.addArrangedSubview(filtersHScrollView)

        return $0
    }(UIStackView())

    private lazy var searchBarView: UIView = {
        $0.addSubview(searchTextField)
        $0.addSubview(showFiltersButton)

        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        showFiltersButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            $0.heightAnchor.constraint(equalToConstant: 40),

            searchTextField.topAnchor.constraint(equalTo: $0.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: $0.bottomAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: $0.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: showFiltersButton.leadingAnchor, constant: -16),

            showFiltersButton.centerYAnchor.constraint(equalTo: $0.centerYAnchor),
            showFiltersButton.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
        ])

        return $0
    }(UIView())

    private lazy var searchTextField = SearchTextField()

    private lazy var showFiltersButton = PlainImageButton(imageName: "icons/filters", active: false, size: .medium)

    private lazy var filtersHScrollView = createHorizontalScrollViewForButtons(buttons: [])

    private lazy var resetButton = FilterOverviewButton(title: "Reset all filters", clickable: true)

    // MARK: - Lifecycle

    init(delegate: FilterSearchViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setSelectorsTargets()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFilter(filter: Filter) {
        filtersHScrollView.removeFromSuperview()
        filtersHScrollView = createHorizontalScrollViewForButtons(buttons: getButtonList(filter: filter))
        mainVStackView.addArrangedSubview(filtersHScrollView)
        showFiltersButton.setActive(!getButtonList(filter: filter).isEmpty)
    }

    private func setSelectorsTargets() {
        showFiltersButton.addTarget(self, action: #selector(pressedFiltersButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(pressedResetButton), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)
    }

    // MARK: - Layout setup

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainVStackView)

        NSLayoutConstraint.activate([
            mainVStackView.topAnchor.constraint(equalTo: topAnchor),
            mainVStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Buttons logic

extension FilterSearchView {
    private func getButtonList(filter: Filter) -> [FilterOverviewButton] {
        var list: [FilterOverviewButton] = []

        if let status = filter.status {
            let title = status == .unknown ? "Unknown" : status.rawValue
            let filterButton = FilterOverviewButton(title: title, clickable: false)
            list.append(filterButton)
        }

        if let gender = filter.gender {
            let title = gender == .unknown ? "Unknown" : gender.rawValue
            let filterButton = FilterOverviewButton(title: title, clickable: false)
            list.append(filterButton)
        }

        if !list.isEmpty {
            list.append(resetButton)
        }

        return list
    }

    private func createHorizontalButtonsStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally

        for button in buttons {
            stackView.addArrangedSubview(button)
        }

        return stackView
    }

    private func createHorizontalScrollViewForButtons(buttons: [UIButton]) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = createHorizontalButtonsStackView(buttons: buttons)

        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        // Bind scrollView's width
        let wConst = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        wConst.isActive = true
        wConst.priority = UILayoutPriority(50)

        return scrollView
    }
}

// MARK: - Selectors

extension FilterSearchView {
    @objc
    private func pressedFiltersButton() {
        delegate?.pressedFiltersButton()
    }

    @objc
    private func pressedResetButton() {
        delegate?.pressedResetButton()
        searchTextField.text = ""
        setFilter(filter: Filter())
    }

    @objc
    private func searchTextFieldDidChange() {
        delegate?.searchTextFieldDidChange(text: searchTextField.text ?? "")
    }
}
