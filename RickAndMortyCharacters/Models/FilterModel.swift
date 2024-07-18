//
//  FilterModel.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 18.07.2024.
//

import Foundation

typealias FilterStatus = (dead: Bool, alive: Bool, unknown: Bool)

typealias FilterGender = (male: Bool, female: Bool, genderless: Bool, unknown: Bool)

struct Filter {
    var status: FilterStatus
    var gender: FilterGender
}

class FilterModel {
    var filter: Filter = Filter(status: (false, false, false), gender: (false, false, false, false))
}
