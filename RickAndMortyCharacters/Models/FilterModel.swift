//
//  FilterModel.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import Foundation

typealias FilterStatus = [Status: Bool]

typealias FilterGender = [Gender: Bool]

struct Filter {
    var status: FilterStatus
    var gender: FilterGender

    static var initialState = Filter(status: [.alive: false, .dead: false, .unknown: false],
                                     gender: [.male: false, .female: false, .genderless: false, .unknown: false])
}

protocol FilterObserver: AnyObject {
    func filterDidUpdate(_ filter: Filter)
}

class FilterModel {
    static var shared = FilterModel()

    private var observers = [FilterObserver]()

    var filter: Filter = Filter.initialState {
        didSet {
            notifyObservers()
        }
    }

    func addObserver(_ observer: FilterObserver) {
        observers.append(observer)
    }

    private func notifyObservers() {
        observers.forEach {
            $0.filterDidUpdate(filter)
        }
    }

    var searchQuery: String = ""
}
