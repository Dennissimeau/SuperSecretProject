//
//  LocationListViewModel.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 27/04/2024.
//

import Foundation
import Observation
import CoreLocation

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
            let locations = try await networkService.fetchLocation()
            self.locations = await enhanceLocationsWithCityName(locations: locations)
            loadState = .retrieved
        } catch {
            loadState = .error(errorMessage: error)
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
