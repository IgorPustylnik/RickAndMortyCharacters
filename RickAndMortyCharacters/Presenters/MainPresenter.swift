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
    
    weak private var inputDelegate: MainInputDelegate?
    
    func setInputDelegate(mainInputDelegate: MainInputDelegate) {
        self.inputDelegate = mainInputDelegate
    }
}

extension MainPresenter: MainOutputDelegate {
    func refreshCharactersList() {
        inputDelegate?.refreshCharactersView(storage.charactersList)
    }
    
    func resetFilterState() {
        filterModel.filter = Filter.initialState
    }
    
    func getFilterState() -> Filter {
        filterModel.filter
    }
    
    func loadMoreCharacters() {
        // TODO: - Network call
    }
    
}
