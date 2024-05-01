//
//  NetworkService.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 27/04/2024.
//

import Foundation

protocol NetworkService {
    func fetchLocation() async throws -> [Location]
}

public final class NetworkManager: NetworkService {
    private let decoder = JSONDecoder()

    func fetchLocation() async throws -> [Location] {
        guard let url = URL(
            string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
        ) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
              HTTPStatusCode(urlResponse: response) == .success else {
            throw NetworkError.noSuccess
        }

        do {
            let container = try decoder.decode(LocationsContainer.self, from: data)
            return container.locations
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
