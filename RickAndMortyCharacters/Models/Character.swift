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
    case unknown = "unknown"
}

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}

struct CharactersList: Codable {
    let info: Info
    var results: [CharacterRaw]
}

struct Info: Codable {
    let pages: Int
}

struct CharacterRaw: Codable {
    let id: Int
    let image: String
    let name: String
    let status: String
    let species: String
    let gender: String
    let episode: [String]
    let location: Location
    
    func convertToCharacterData() -> CharacterData? {
        guard let status: Status = Status.init(rawValue: status) else { print("error converting"); return nil }
        guard let gender: Gender = Gender.init(rawValue: gender) else { print("error converting"); return nil }

        var episodesNames: [String] = []
        
        for episodeUrl in episode {
            DispatchQueue.main.async {
                NetworkManager.shared.getEpisodesName(url: URL(string: episodeUrl)) { result in
                    switch result {
                    case .success(let name):
                        episodesNames.append(name)
                        
                    case .failure(let error):
                        print("Error finding episode's name")
                    }
                }
            }
        }
        
        var character = CharacterData(id: id, image: nil, name: name, status: status, species: species, gender: gender, episodes: episodesNames, location: location.name)
        
        return character
    }
}

struct Episode: Codable {
    let name: String
}

struct Location: Codable {
    let name: String
}

class CharacterData {
    let id: Int
    var image: UIImage?
    let name: String
    let status: Status
    let species: String
    let gender: Gender
    var episodes: [String]
    let location: String
    
    init(id: Int, image: UIImage?, name: String, status: Status, species: String, gender: Gender, episodes: [String], location: String) {
        self.id = id
        self.image = image
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.episodes = episodes
        self.location = location
    }
}
