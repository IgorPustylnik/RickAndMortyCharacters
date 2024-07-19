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
        networkManager.setDelegate(delegate: self)
        storage.addObserver(self)
        filterModel.addObserver(self)
    }
    
    weak private var inputDelegate: MainInputDelegate?
    
    func setInputDelegate(mainInputDelegate: MainInputDelegate) {
        self.inputDelegate = mainInputDelegate
    }
}

extension MainPresenter: DataStorageObserver {
    func storageDidUpdate(_ charactersList: [CharacterData]) {
        DispatchQueue.main.async {
            self.inputDelegate?.refreshCharactersView(charactersList)
        }
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
        storage.resetCurrentPage()
        networkManager.fetchCharacters(filter: filterModel.filter) {}
    }
    
    func getFilterState() -> Filter {
        filterModel.filter
    }
    
    func setSearchQuery(_ query: String) {
        filterModel.filter.name = query
        storage.resetCurrentPage()
        networkManager.fetchCharacters(filter: filterModel.filter) {}
    }
    
    func loadCharacters(completion: @escaping () -> Void) { 
        networkManager.fetchCharacters(filter: filterModel.filter) {
            completion()
        }
    }
    
    func isLastPage() -> Bool? {
        return storage.isLastPage()
    }
    
}

extension MainPresenter: NetworkManagerDelegate {
    func refreshViews() {
        inputDelegate?.refreshCharactersView(storage.charactersList)
    }
}
