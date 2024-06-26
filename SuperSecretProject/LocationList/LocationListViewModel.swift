//
//  LocationListViewModel.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 27/04/2024.
//

import CoreLocation
import Foundation
import Observation

@Observable
public final class LocationListViewModel {
    private var networkService: NetworkService

    public var loadState: LoadState = .start
    public var locations: [Location] = []

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    public func fetchLocations() async {
        loadState = .loading
        do {
            let fetchedLocations = try await networkService.fetchLocation()
            let locations = await enhanceLocationsWithCityName(locations: fetchedLocations)
            self.locations.append(contentsOf: locations)
            loadState = .retrieved
        } catch {
            if let networkError = error as? NetworkError {
                loadState = .error(errorMessage: networkError.errorDescription)
            } else {
                loadState = .error(errorMessage: error.localizedDescription)
            }
        }
    }

    private func enhanceLocationsWithCityName(locations: [Location]) async -> [Location] {
        var updatedLocations = [Location]()
        for location in locations {
            var modifiedLocation = location
            if modifiedLocation.name == nil {
                modifiedLocation.name = await CLLocation(
                    latitude: modifiedLocation.lat,
                    longitude: modifiedLocation.long
                )
                .getNearbyCity()
            }
            updatedLocations.append(modifiedLocation)
        }
        return updatedLocations
    }
}
