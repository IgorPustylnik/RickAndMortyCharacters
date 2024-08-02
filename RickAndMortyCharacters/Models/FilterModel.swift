//
//  FilterModel.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import Foundation

// MARK: - FilterObserver protocol

protocol FilterObserver: AnyObject {
    func filterDidUpdate(_ filter: Filter)
}

// MARK: - FilterModel

class FilterModel {
    static var shared = FilterModel()

    private var observers = [FilterObserver]()

    var filter: Filter = Filter() {
        didSet {
            notifyObservers()
        }
    }
}

// MARK: - Observer

extension FilterModel {
    func addObserver(_ observer: FilterObserver) {
        observers.append(observer)
    }

    private func notifyObservers() {
        observers.forEach {
            $0.filterDidUpdate(filter)
        }
    }
}
