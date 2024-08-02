//
//  DataStorage.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import Foundation
import UIKit

// MARK: - DataStorageObserver

protocol DataStorageObserver: AnyObject {
    func storageDidUpdate(_ charactersList: [CharacterData])
}

// MARK: - DataStorage

class DataStorage {
    static let shared = DataStorage()

    private var observers = [DataStorageObserver]()

    var charactersList: [CharacterData] = [] {
        didSet {
            notifyObservers()
        }
    }

    private var currentPage: Int = 0
    private var totalPages: Int = -1
}

// MARK: - Mock data source

extension DataStorage {
    private static var mockList: [CharacterData] = [
        CharacterData(id: 0,
                      image: UIImage(named: "images/splashScreenBackground"),
                      name: "Character 1",
                      status: .alive,
                      species: "Human",
                      gender: .male,
                      episodes: ["fadfadfgagfadgadgadadgagadgadgadgadgadgadgadadgadgaagadg",
                                 "sknfhsnhdsjkgsjgnsjkgksjdgsjkdgkdb"],
                      location: "Earth"),
        CharacterData(id: 1,
                      image: nil,
                      name: "Character 2",
                      status: .dead,
                      species: "Reptile",
                      gender: .female,
                      episodes: [],
                      location: "Earth"),
        CharacterData(id: 2,
                      image: nil,
                      name: "Character 3",
                      status: .alive,
                      species: "Human",
                      gender: .male,
                      episodes: [],
                      location: "Earth"),
        CharacterData(id: 3,
                      image: nil,
                      name: "Character 4",
                      status: .unknown,
                      species: "Human",
                      gender: .genderless,
                      episodes: [],
                      location: "Earth"),
        CharacterData(id: 4,
                      image: nil,
                      name: "Character 5",
                      status: .dead,
                      species: "Human",
                      gender: .male,
                      episodes: [],
                      location: "Earth"),
        CharacterData(id: 0,
                      image: UIImage(named: "images/splashScreenBackground"),
                      name: "Character 1",
                      status: .alive,
                      species: "Human",
                      gender: .male,
                      episodes: ["fadfadfgagfadgadgadadgagadgadgadgadgadgadgadadgadgaagadg",
                                 "sknfhsnhdsjkgsjgnsjkgksjdgsjkdgkdb"],
                      location: "Earth"),
        CharacterData(id: 1,
                      image: nil,
                      name: "Character 2",
                      status: .dead,
                      species: "Reptile",
                      gender: .female,
                      episodes: [],
                      location: "Earth"),
        CharacterData(id: 2,
                      image: nil,
                      name: "Character 3",
                      status: .alive,
                      species: "Human",
                      gender: .male,
                      episodes: [],
                      location: "Earth"),
        CharacterData(id: 3,
                      image: nil,
                      name: "Character 4",
                      status: .unknown,
                      species: "Human",
                      gender: .genderless,
                      episodes: [],
                      location: "Earth"),
        CharacterData(id: 4,
                      image: nil,
                      name: "Character 5",
                      status: .dead,
                      species: "Human",
                      gender: .male,
                      episodes: [],
                      location: "Earth")
    ]
}

// MARK: - Pages logic

extension DataStorage {
    public func incrementCurrentPage() -> Int {
        if !isLastPage() {
            currentPage += 1
            print("Current page: \(currentPage) out of \(totalPages)")
            return currentPage
        } else {
            return currentPage
        }
    }

    public func isLastPage() -> Bool {
        return currentPage == totalPages
    }

    public func getCurrentPage() -> Int {
        return currentPage
    }

    public func resetCurrentPage() {
        currentPage = 0
    }

    public func getTotalPages() -> Int {
        return totalPages
    }

    public func setTotalPages(_ pages: Int) {
        totalPages = pages
    }
}

// MARK: Observers

extension DataStorage {
    func addObserver(_ observer: DataStorageObserver) {
        observers.append(observer)
    }

    private func notifyObservers() {
        observers.forEach {
            $0.storageDidUpdate(charactersList)
        }
    }
}
