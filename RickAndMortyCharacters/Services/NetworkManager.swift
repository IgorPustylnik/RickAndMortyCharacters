//
//  NetworkManager.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import Foundation
import UIKit

// MARK: - Custom errors

enum Error: Swift.Error {
    case generic
    case invalidUrl
    case dataNotFound
    case decoding
}

// MARK: - NetworkManagerDelegate protocol

protocol NetworkManagerDelegate: AnyObject {
    func refreshViews()
}

// MARK: - NetworkManager

class NetworkManager {
    static let shared = NetworkManager()
    private weak var delegate: NetworkManagerDelegate?

    let filterModel = FilterModel.shared
    let storage = DataStorage.shared

    func setDelegate(delegate: NetworkManagerDelegate) {
        self.delegate = delegate
    }
}

// MARK: - Fetching functions

extension NetworkManager {

    private func fetchCharactersRawList(filter: Filter, page: Int,
                                        completion: @escaping (Result<CharactersList, Swift.Error>) -> Void) {
        guard let url = APIEndpoint.charactersFilter(filter: filter, page: page).url else { return }

        print("Fetching characters started: \(page)")

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(Error.dataNotFound))
                return
            }

            do {
                let rawCharactersList = try JSONDecoder().decode(CharactersList.self, from: data)
                completion(.success(rawCharactersList))
                return
            } catch {
                completion(.failure(Error.decoding))
                return
            }
        }
        task.resume()
    }

    public func fetchCharacters(filter: Filter, completion: @escaping () -> Void) {
        guard !storage.isLastPage() else { return }
        let nextPage = storage.incrementCurrentPage()
        fetchCharactersRawList(filter: filter, page: nextPage) { result in
            switch result {
            case .failure(Error.decoding):
                self.storage.resetCurrentPage()
                self.storage.setTotalPages(-1)
                self.storage.charactersList.removeAll()
                DispatchQueue.main.async {
                    self.delegate?.refreshViews()
                    completion()
                }
            case let .failure(error):
                print("Error occured: \(error)")

            case let .success(data):
                self.storage.setTotalPages(data.info.pages)
                if nextPage == 1 {
                    self.storage.charactersList.removeAll()
                    for characterRaw in data.results {
                        if let characterData = characterRaw.convertToCharacterData() {
                            self.storage.charactersList.append(characterData)
                            self.fetchCharacterImage(url: URL(string: characterRaw.image), character: characterData)
                            self.fetchCharacterEpisodes(episodes: characterRaw.episode, character: characterData)
                        }
                    }
                } else {
                    for characterRaw in data.results {
                        if let characterData = characterRaw.convertToCharacterData() {
                            self.storage.charactersList.append(characterData)
                            self.fetchCharacterImage(url: URL(string: characterRaw.image), character: characterData)
                            self.fetchCharacterEpisodes(episodes: characterRaw.episode, character: characterData)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.delegate?.refreshViews()
                    completion()
                }
            }
        }
    }

    private func fetchCharacterImage(url: URL?, character: CharacterData) {
        guard let url else { return }
        NetworkManager.shared.fetchData(from: url) { result in
            switch result {
            case let .success(data):
                character.image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.delegate?.refreshViews()
                }
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }

    private func fetchCharacterEpisodes(episodes: [String], character: CharacterData) {
        var stringEpisodes: [String] = []
        let dispatchGroup = DispatchGroup()

        for episode in episodes {
            dispatchGroup.enter()
            guard let url = URL(string: episode) else { return }
            NetworkManager.shared.fetchEpisodesName(url: url) { result in
                defer { dispatchGroup.leave() }
                switch result {
                case let .failure(error):
                    print(error)
                case let .success(data):
                    stringEpisodes.append(data)
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            character.episodes = stringEpisodes
            self.delegate?.refreshViews()
        }
    }

    public func fetchEpisodesName(url: URL?, completion: @escaping (Result<String, Swift.Error>) -> Void) {
        guard let url else { completion(.failure(Error.invalidUrl)); return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(Error.dataNotFound))
                return
            }

            do {
                let rawEpisode = try JSONDecoder().decode(Episode.self, from: data)
                completion(.success(rawEpisode.name))
                return
            } catch {
                completion(.failure(Error.decoding))
                return
            }
        }
        task.resume()
    }

    func fetchData(from url: URL?, completion: @escaping (Result<Data, Swift.Error>) -> Void) {
        guard let url else { completion(.failure(Error.invalidUrl)); return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(Error.dataNotFound))
                return
            }

            completion(.success(data))
        }
        .resume()
    }
}
