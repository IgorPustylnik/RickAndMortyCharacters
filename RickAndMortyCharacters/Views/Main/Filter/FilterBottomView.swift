//
//  FilterBottomView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

protocol FilterBottomViewDelegate: AnyObject {
    func pressedApplyFilter(with filter: Filter)
    func pressedClose()
}

class FilterBottomView: UIView {
    
    private var filter: Filter
    private weak var delegate: FilterBottomViewDelegate?

    // MARK: - Main stack view

    private lazy var mainVStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 24
        $0.distribution = .fill
        $0.alignment = .fill

        $0.addArrangedSubview(navView)
        $0.addArrangedSubview(filtersVStack)
        $0.addArrangedSubview(applyButton)

        return $0
    }(UIStackView())

    // MARK: - Navigation view

    private lazy var navView: UIView = {
        $0.addSubview(closeButton)
        $0.addSubview(navTitle)
        $0.addSubview(resetButton)

        NSLayoutConstraint.activate([
            $0.heightAnchor.constraint(equalToConstant: 26),

            closeButton.centerYAnchor.constraint(equalTo: $0.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: $0.leadingAnchor),

            navTitle.centerXAnchor.constraint(equalTo: $0.centerXAnchor),
            navTitle.centerYAnchor.constraint(equalTo: $0.centerYAnchor),

            resetButton.centerYAnchor.constraint(equalTo: $0.centerYAnchor),
            resetButton.trailingAnchor.constraint(equalTo: $0.trailingAnchor),
        ])
        return $0
    }(UIView())

    private lazy var closeButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(systemName: "xmark")?.withTintColor(.Colors.mainText, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .clear

        return $0
    }(UIButton())

    private lazy var navTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.IBMPlexSans.semiBold(size: 20)
        $0.textColor = .Colors.mainText
        $0.text = "Filters"
        return $0
    }(UILabel())

    private lazy var resetButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.borderless()
        configuration.baseForegroundColor = .Colors.aqua
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.attributedTitle = AttributedString("Reset", attributes: AttributeContainer([.font: UIFont.IBMPlexSans.regular(size: 14)]))
        $0.configuration = configuration
        return $0
    }(UIButton())

    // MARK: - Filters

    private lazy var filtersVStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill

        $0.addArrangedSubview(statusVStack)
        $0.addArrangedSubview(genderVStack)

        return $0
    }(UIStackView())

    // MARK: - Status filter

    private lazy var statusVStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill

        let label = UILabel()
        label.font = UIFont.IBMPlexSans.medium(size: 14)
        label.textColor = .Colors.mainText
        label.text = "Status"

        $0.addArrangedSubview(label)
        $0.addArrangedSubview(statusButtonsScrollView)

        return $0
    }(UIStackView())

    private lazy var statusButtons: [Status: FilterToggleButton] = [
        .dead: deadStatusButton,
        .alive: aliveStatusButton,
        .unknown: unknownStatusButton,
    ]

    private lazy var statusButtonsScrollView = createHorizontalScrollViewForButtons(buttons: statusButtons.values.map( { $0 } ))

    private lazy var deadStatusButton = FilterToggleButton(title: "Dead", isOn: filter.status[.dead]!)
    private lazy var aliveStatusButton = FilterToggleButton(title: "Alive", isOn: filter.status[.alive]!)
    private lazy var unknownStatusButton = FilterToggleButton(title: "Unknown", isOn: filter.status[.unknown]!)

    // MARK: - Gender filter

    private lazy var genderVStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill

        let label = UILabel()
        label.font = UIFont.IBMPlexSans.medium(size: 14)
        label.textColor = .Colors.mainText
        label.text = "Gender"

        $0.addArrangedSubview(label)
        $0.addArrangedSubview(genderButtonsScrollView)

        return $0
    }(UIStackView())

    private lazy var genderButtons: [Gender: FilterToggleButton] = [
        .male: maleGenderButton,
        .female: femaleGenderButton,
        .genderless: genderlessButton,
        .unknown: unknownGenderButton,
    ]

    private lazy var genderButtonsScrollView = createHorizontalScrollViewForButtons(buttons: genderButtons.values.map { $0 })
    
    private lazy var maleGenderButton = FilterToggleButton(title: "Male", isOn: filter.gender[.male]!)
    private lazy var femaleGenderButton = FilterToggleButton(title: "Female", isOn: filter.gender[.female]!)
    private lazy var genderlessButton = FilterToggleButton(title: "Genderless", isOn: filter.gender[.genderless]!)
    private lazy var unknownGenderButton = FilterToggleButton(title: "Unknown", isOn: filter.gender[.unknown]!)

    // MARK: - Apply button

    private lazy var applyButton = CustomAquaButton(title: "Apply")

    // MARK: - Lifecycle

    init(filter: Filter) {
        self.filter = filter
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDelegate(_ delegate: FilterBottomViewDelegate) {
        self.delegate = delegate
    }

    func setFilter(_ filter: Filter) {
        self.filter = filter
    }

    // MARK: - Layout setup

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setupButtonsTargets()

        addSubview(mainVStack)

        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
//            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Buttons logic
    
    private func setupButtonsTargets() {
        closeButton.addTarget(self, action: #selector(pressedCloseButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(pressedResetButton), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(pressedApplyButton), for: .touchUpInside)
    }
    
    private func updateButtonStates() {
        Gender.allCases.forEach { genderType in
            var button = genderButtons[genderType]
            button?.setActive(filter.gender[genderType]!)
        }
        Status.allCases.forEach { statusType in
            var button = statusButtons[statusType]
            button?.setActive(filter.status[statusType]!)
        }
    }

    // MARK: - Selectors

    @objc
    private func pressedApplyButton() {
        // Save buttons state
        for (genderType, button) in genderButtons {
            filter.gender[genderType] = button.getButtonState()
        }
        for (statusType, button) in statusButtons {
            filter.status[statusType] = button.getButtonState()
        }

        delegate?.pressedApplyFilter(with: filter)
    }

    @objc
    private func pressedCloseButton() {
        delegate?.pressedClose()
    }

    @objc func pressedResetButton() {
        filter = Filter.initialState
        updateButtonStates()
    }
}

// MARK: - Elements constructors

extension FilterBottomView {
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

            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])

        // Bind scrollView's width
        let wConst = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        wConst.isActive = true
        wConst.priority = UILayoutPriority(50)

        return scrollView
    }
}
