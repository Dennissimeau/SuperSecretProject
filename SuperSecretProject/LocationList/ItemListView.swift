//
//  ItemListView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 01/05/2024.
//

import SwiftUI
import TipKit

struct ItemListView: View {
    private let locationNameTip = LocationNameTip()

    var locations: [Location]
    var openWikipedia: (Double, Double) -> Void

    var body: some View {
        List(locations, id: \.self) { location in
            LocationItemView(location: location)
                .onTapGesture {
                    openWikipedia(location.lat, location.long)
                }
                .accessibilityLabel("Open in Wikipedia")
                .popoverTip(locationNameTip, arrowEdge: .top)
        }
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
    }
}
