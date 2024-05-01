//
//  LocationItemView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 01/05/2024.
//

import SwiftUI

struct LocationItemView: View {
    var location: Location

    var body: some View {
        VStack(alignment: .leading) {
            if let name = location.name {
                Text(name)
                    .bold()
                    .accessibilityLabel("Location name: \(name)")
            }
            HStack {
                Text(String(format: "%.7f", location.lat))
                Text(String(format: "%.7f", location.long))
                Spacer()
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Coordinates: Latitude \(location.lat), Longitude \(location.long)")
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
