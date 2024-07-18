//
//  DataStorage.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import Foundation
import UIKit

class DataStorage {
    static let shared = DataStorage()
    
    var charactersList: [CharacterData] = [
        CharacterData(id: 0, image: UIImage(named: "images/splashScreenBackground"), name: "Character 1", status: .alive, species: "Human", gender: .male, episodes: ["fadfadfgagfadgadgadadgagadgadgadgadgadgadgadadgadgaagadg", "sknfhsnhdsjkgsjgnsjkgksjdgsjkdgkdb"], location: "Earth"),
        CharacterData(id: 1, image: nil, name: "Character 2", status: .dead, species: "Reptile", gender: .female, episodes: [], location: "Earth"),
        CharacterData(id: 2, image: nil, name: "Character 3", status: .alive, species: "Human", gender: .male, episodes: [], location: "Earth"),
        CharacterData(id: 3, image: nil, name: "Character 4", status: .unknown, species: "Human", gender: .genderless, episodes: [], location: "Earth"),
        CharacterData(id: 4, image: nil, name: "Character 5", status: .dead, species: "Human", gender: .male, episodes: [], location: "Earth"),
        CharacterData(id: 0, image: UIImage(named: "images/splashScreenBackground"), name: "Character 1", status: .alive, species: "Human", gender: .male, episodes: ["fadfadfgagfadgadgadadgagadgadgadgadgadgadgadadgadgaagadg", "sknfhsnhdsjkgsjgnsjkgksjdgsjkdgkdb"], location: "Earth"),
        CharacterData(id: 1, image: nil, name: "Character 2", status: .dead, species: "Reptile", gender: .female, episodes: [], location: "Earth"),
        CharacterData(id: 2, image: nil, name: "Character 3", status: .alive, species: "Human", gender: .male, episodes: [], location: "Earth"),
        CharacterData(id: 3, image: nil, name: "Character 4", status: .unknown, species: "Human", gender: .genderless, episodes: [], location: "Earth"),
        CharacterData(id: 4, image: nil, name: "Character 5", status: .dead, species: "Human", gender: .male, episodes: [], location: "Earth"),
    ]
}
