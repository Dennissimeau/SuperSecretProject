//
//  CLLocation+Extensions.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 28/04/2024.
//

import Foundation
import CoreLocation

extension CLLocation {
    func getNearbyCity() async -> String? {
        do {
            let reverse = try await CLGeocoder().reverseGeocodeLocation(self)
            guard let locality = reverse.first?.locality else { return nil }
            return  "✨ \(locality)"
        } catch {
            return nil
        }
    }
}
