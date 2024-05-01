//
//  MapView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 01/05/2024.
//

import CoreLocation
import MapKit
import SwiftUI

struct MapView: View {
    var coordinate: CLLocationCoordinate2D

    var body: some View {
        Map(position: .constant(.region(region)), interactionModes: [])
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}
