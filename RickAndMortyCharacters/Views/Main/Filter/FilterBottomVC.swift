//
//  FilterView.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import UIKit

protocol FilterOutputDelegate: AnyObject {
    func applyFilter(_ filter: Filter)
    func closeFilter()
}

class FilterBottomVC: UIViewController {
    
    private var filter: Filter
    weak private var outputDelegate: FilterOutputDelegate?
    
    private lazy var bottomView = FilterBottomView(filter: filter)
    
    init(filter: Filter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOutputDelegate(outputDelegate: FilterOutputDelegate) {
        self.outputDelegate = outputDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.setDelegate(self)
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

extension FilterBottomVC: FilterBottomViewDelegate {
    
    func pressedApplyFilter(with filter: Filter) {
        outputDelegate?.applyFilter(filter)
    }
    
    func pressedClose() {
        outputDelegate?.closeFilter()
    }
    
}
