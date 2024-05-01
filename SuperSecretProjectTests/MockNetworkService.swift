//
//  MockNetworkService.swift
//  SuperSecretProjectTests
//
//  Created by Dennis Vermeulen on 28/04/2024.
//

import Foundation

public final class MockNetworkService: NetworkService {
    public var items: [Location]? = nil
    public var error: NetworkError? = nil

    init(items: [Location]? = nil, error: NetworkError? = nil) {
        self.items = items
        self.error = error
    }

    func fetchLocation() async throws -> [Location] {
        if let error = error {
            throw error
        } else if let items = items {
            return items
        } else {
            throw NetworkError.noSuccess
        }
    }
}
