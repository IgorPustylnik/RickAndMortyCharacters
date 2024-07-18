//
//  FilterBottomSheetPresenter.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import Foundation

class FilterPresenter {
    
    private let storage = DataStorage.shared
    private let filterModel = FilterModel.shared
    
    weak private var inputDelegate: FilterInputDelegate?
    
    func setInputDelegate(mainInputDelegate: FilterInputDelegate) {
        self.inputDelegate = mainInputDelegate
    }
}

extension FilterPresenter: FilterOutputDelegate {
    
    func applyFilter(_ filter: Filter) {
        filterModel.filter = filter
    }
    
    func refreshFilterOnView() {
        inputDelegate?.resfreshFilterOnView(filter: filterModel.filter)
    }
}
