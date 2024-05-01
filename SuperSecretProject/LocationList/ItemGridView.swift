//
//  ItemGridView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 01/05/2024.
//

import SwiftUI
import CoreLocation

struct ItemGridView: View {
    private let columns = [
        GridItem(.adaptive(minimum: 175))
    ]
    var locations: [Location]
    var openWikipedia: (Double, Double) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(locations, id: \.hashValue) { location in
                    VStack(alignment: .leading) {
                        MapView(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long))
                        LocationItemView(location: location)
                    }
                    .frame(width: 175, height: 175)
                    .contentShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        openWikipedia(location.lat, location.long)

                    }
                    .accessibilityAction(named: "Open in Wikipedia") {
                        openWikipedia(location.lat, location.long)
                    }
                }
            }
            .padding([.top, .horizontal])
        }
    }
}
