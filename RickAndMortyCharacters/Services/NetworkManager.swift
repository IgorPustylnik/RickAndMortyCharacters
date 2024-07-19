//
//  NetworkManager.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import Foundation
import UIKit

enum APIEndpoint {
    case charactersFilter(filter: Filter, page: Int)
    case characterImage(id: Int)
    case episodeName(id: Int)

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"

        switch self {
        case let .charactersFilter(filter, page):
            components.path = "/api/character/"
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
            if let name = filter.name {
                queryItems.append(URLQueryItem(name: "name", value: name))
            }
            if let status = filter.status {
                queryItems.append(URLQueryItem(name: "status", value: status.rawValue))
            }
            if let gender = filter.gender {
                queryItems.append(URLQueryItem(name: "gender", value: gender.rawValue))
            }
            components.queryItems = queryItems
            return components.url

        case let .characterImage(id):
            components.path = "/api/character/avatar/\(id).jpeg"
            return components.url

        case let .episodeName(id):
            components.path = "/api/episode/\(id)"
            return components.url
        }
    }
}

enum Error: Swift.Error {
    case generic
    case invalidUrl
    case dataNotFound
    case decoding
}

protocol NetworkManagerDelegate: AnyObject {
    func refreshViews()
}

class NetworkManager {
    static let shared = NetworkManager()
    private weak var delegate: NetworkManagerDelegate?

    let filterModel = FilterModel.shared
    let storage = DataStorage.shared

    func setDelegate(delegate: NetworkManagerDelegate) {
        self.delegate = delegate
    }

    private func fetchCharactersRawList(filter: Filter, page: Int,
                                        completion: @escaping (Result<CharactersList, Error>) -> Void) {
        guard let url = APIEndpoint.charactersFilter(filter: filter, page: page).url else { return }

        print("Fetching characters started: \(page)")

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(.generic))
                return
            }
            guard let data else {
                completion(.failure(.dataNotFound))
                return
            }

            do {
                let rawCharactersList = try JSONDecoder().decode(CharactersList.self, from: data)
                completion(.success(rawCharactersList))
                return
            } catch {
                completion(.failure(.decoding))
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
            case let .failure(.decoding):
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
                        if var characterData = characterRaw.convertToCharacterData() {
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
        NetworkManager.shared.getData(from: url) { result in
            switch result {
            case let .success(data):
                character.image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.delegate?.refreshViews()
                }
            case let .failure(error):
                print("Error downloading image")
            }
        }
    }

    private func fetchCharacterEpisodes(episodes: [String], character: CharacterData) {
        var stringEpisodes: [String] = []
        let dispatchGroup = DispatchGroup()

        for episode in episodes {
            dispatchGroup.enter()
            guard let url = URL(string: episode) else { return }
            NetworkManager.shared.getEpisodesName(url: url) { result in
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

    public func getEpisodesName(url: URL?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url else { completion(.failure(.invalidUrl)); return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(.generic))
                return
            }
            guard let data else {
                completion(.failure(.dataNotFound))
                return
            }

            do {
                let rawEpisode = try JSONDecoder().decode(Episode.self, from: data)
                completion(.success(rawEpisode.name))
                return
            } catch {
                completion(.failure(.decoding))
                return
            }
        }
        task.resume()
    }

    func getData(from url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url else { completion(.failure(.invalidUrl)); return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(.generic))
                return
            }
            guard let data else {
                completion(.failure(.dataNotFound))
                return
            }

            completion(.success(data))
        }
        .resume()
    }
}
