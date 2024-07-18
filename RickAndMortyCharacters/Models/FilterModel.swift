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

class FilterModel {
    var filter: Filter = Filter.initialState
}
