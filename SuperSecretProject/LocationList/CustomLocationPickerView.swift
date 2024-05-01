//
//  CustomLocationPickerView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 29/04/2024.
//

import CoreLocation
import MapKit
import SwiftUI

struct CustomLocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var region: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: .init(latitude: 37.3347302, longitude: -122.0089189),
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
    )

    @State private var locationTitle: String = "Pick your location"
    @State private var cameraLocation: MKCoordinateRegion = MKCoordinateRegion()
    @State private var textfieldText: String = ""

    var viewModel: LocationListViewModel

    private func getLocationName(coordinate: CLLocationCoordinate2D) async -> String {
        return await CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            .getNearbyCity() ?? "Unknown"
    }

    private func addUserAddedLocation() {
        viewModel.locations.append(
            Location(
                name: locationTitle,
                lat: cameraLocation.center.latitude,
                long: cameraLocation.center.longitude,
                isUserAdded: true
            )
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            titleView
            Map(position: $region, interactionModes: [.pan, .zoom])
                .onMapCameraChange(frequency: .onEnd) { context in
                    Task {
                        locationTitle = await getLocationName(coordinate: context.region.center)
                    }
                    UIAccessibility.post(notification: .announcement, argument: locationTitle)
                    cameraLocation = context.region
                }
                .accessibilityLabel("Map showing locations")
                .accessibilityValue("Currently showing \(locationTitle)")
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 10, x: 2, y: 2)
            addButton
                .padding(.top)
        }
        .padding()
    }

    private var titleView: some View {
        Group {
            Text(locationTitle)
                .bold()
                .font(.title)
                .accessibilityLabel("Selected location \(locationTitle)")
            Text("Search the map for your favorite location")
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityLabel("Instructions: Search the map for your favorite location by moving around.")
        }
        .accessibilityElement(children: .combine)
    }

    private var addButton: some View {
        Button(action: {
            addUserAddedLocation()
            dismiss()
        }) {
            Text("Add location")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .bold()
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .accessibilityLabel("Add location")
        .accessibilityHint("Adds the currently selected location to your list")
    }
}

#Preview {
    CustomLocationPickerView(viewModel: LocationListViewModel(networkService: NetworkManager()))
}
