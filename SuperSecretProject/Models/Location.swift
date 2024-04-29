//
//  Location.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 28/04/2024.
//

import Foundation

public struct LocationsContainer: Decodable {
    public let locations: [Location]
}

public struct Location: Decodable, Hashable {    
    var name: String?
    let lat: Double
    let long: Double
    
    let isUserAdded: Bool?
}
