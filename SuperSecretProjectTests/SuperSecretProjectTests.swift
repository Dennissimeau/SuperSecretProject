//
//  SuperSecretProjectTests.swift
//  SuperSecretProjectTests
//
//  Created by Dennis Vermeulen on 27/04/2024.
//

import XCTest
@testable import SuperSecretProject

final class SuperSecretProjectTests: XCTestCase {
    func testFetchItemsSuccess() async {
        let items = [
            Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339215),
            Location(name: "Mumbai", lat: 19.0823998, long: 72.8111468),
            Location(name: "Copenhagen", lat: 55.6713442, long: 12.523785),
            Location(lat: 40.4380638, long: -3.7495758)
        ]
        
        let mockService: NetworkService = MockNetworkService(items: items)
    
        let viewModel = LocationListViewModel(networkService: mockService)
        
        XCTAssertEqual(viewModel.locations.count, 0)
        XCTAssertEqual(viewModel.loadState, .start)
        
        await viewModel.fetchLocations()
        
        XCTAssertEqual(viewModel.locations.count, 4)
        XCTAssertEqual(viewModel.loadState, .retrieved)
    }
    
    func testFetchItemsFails() async {
        let mockService: NetworkService = MockNetworkService(error: .decodingFailed)
        let viewModel = LocationListViewModel(networkService: mockService)
        
        XCTAssertEqual(viewModel.locations.count, 0)
        XCTAssertEqual(viewModel.loadState, .start)
        
        await viewModel.fetchLocations()
        
        XCTAssertEqual(viewModel.locations.count, 0)
        XCTAssertEqual(viewModel.loadState, .error(errorMessage: NetworkError.decodingFailed))
        XCTAssertNotEqual(viewModel.loadState, .error(errorMessage: NetworkError.invalidURL))
    }
    
    func testFetchItemsEnhancedLocation() async {
    let items = [
        Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339215),
        Location(name: "Mumbai", lat: 19.0823998, long: 72.8111468),
        Location(name: "Copenhagen", lat: 55.6713442, long: 12.523785),
        Location(lat: 40.4380638, long: -3.7495758), // Madrid
        Location(lat: 37.3347302, long: -122.0089189) // Cupertino (Apple Park)
    ]
        let mockService: NetworkService = MockNetworkService(items: items)
        let viewModel = LocationListViewModel(networkService: mockService)
        
        await viewModel.fetchLocations()
        
        XCTAssertEqual(viewModel.locations[0].name, "Amsterdam")
        XCTAssertEqual(viewModel.locations[3].name, "✨ Madrid")
        XCTAssertEqual(viewModel.locations[4].name, "✨ Cupertino")
    }
}
