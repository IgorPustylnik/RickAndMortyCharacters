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
    private let networkManager = NetworkManager.shared

    private weak var inputDelegate: FilterInputDelegate?

    func setInputDelegate(mainInputDelegate: FilterInputDelegate) {
        inputDelegate = mainInputDelegate
    }
}

extension FilterPresenter: FilterOutputDelegate {
    func applyFilter(_ filter: Filter) {
        filterModel.filter = filter
        storage.resetCurrentPage()
        networkManager.fetchCharacters(filter: filter) {}
    }

    func refreshFilterOnView() {
        inputDelegate?.resfreshFilterOnView(filter: filterModel.filter)
    }
}
