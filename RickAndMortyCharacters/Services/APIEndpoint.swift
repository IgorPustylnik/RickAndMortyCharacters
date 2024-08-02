//
//  APIEndpoint.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 02.08.2024.
//

import Foundation

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
