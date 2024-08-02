//
//  FilterModel.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import Foundation

typealias FilterGender = [Gender: Bool]

struct Filter {
    var name: String?
    var status: Status?
    var gender: Gender?
}

protocol FilterObserver: AnyObject {
    func filterDidUpdate(_ filter: Filter)
}

class FilterModel {
    static var shared = FilterModel()

    private var observers = [FilterObserver]()

    var filter: Filter = Filter() {
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
}
