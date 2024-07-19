//
//  MainPresenter.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import Foundation

class MainPresenter {
    
    private let storage = DataStorage.shared
    private let filterModel = FilterModel.shared
    private let networkManager = NetworkManager.shared
    
    init() {
        filterModel.addObserver(self)
    }
    
    weak private var inputDelegate: MainInputDelegate?
    
    func setInputDelegate(mainInputDelegate: MainInputDelegate) {
        self.inputDelegate = mainInputDelegate
    }
}

extension MainPresenter: FilterObserver {
    func filterDidUpdate(_ filter: Filter) {
        inputDelegate?.refreshFiltersView(with: filter)
    }
}

extension MainPresenter: MainOutputDelegate {
    func refreshCharactersList() {
        inputDelegate?.refreshCharactersView(storage.charactersList)
    }
    
    func resetFilterState() {
        filterModel.filter = Filter()
    }
    
    func getFilterState() -> Filter {
        filterModel.filter
    }
    
    func setSearchQuery(_ query: String) {
        filterModel.searchQuery = query
    }
    
    func loadMoreCharacters() {
        // TODO: - Network call
    }
    
}
