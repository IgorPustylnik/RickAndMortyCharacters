//
//  Character.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import Foundation
import UIKit

enum Status: String, CaseIterable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "Unknown"
}


struct CharacterData {
    let id: Int
    let image: UIImage?
    let name: String
    let status: Status
    let species: String
    let gender: Gender
    let episodes: [String] // TODO: - come up with something different
    let location: String
}
