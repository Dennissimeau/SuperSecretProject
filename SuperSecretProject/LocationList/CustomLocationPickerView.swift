//
//  CustomLocationPickerView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 29/04/2024.
//

import SwiftUI
import CoreLocation
import MapKit

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
        return await CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).getNearbyCity() ?? "Unknown"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleView
            Map(position: $region, interactionModes: [.pan, .zoom])
                .onMapCameraChange(frequency: .onEnd) { context in
                    Task {
                        locationTitle = await getLocationName(coordinate: context.region.center)
                    }
                    cameraLocation = context.region
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 10, x: 2, y: 2)
            HStack {
                Spacer()
                addButton
                Spacer()
            }
            .padding(.top)
        }
        .padding()
    }
    
    var titleView: some View {
        Group {
            Text(locationTitle)
                .bold()
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("Search the map for your favorite location")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    var addButton: some View {
        Button("Add location", action: {
            viewModel.locations.append(
                Location(
                    name: locationTitle,
                    lat: cameraLocation.center.latitude,
                    long: cameraLocation.center.longitude,
                    isUserAdded: true
                )
            )
            dismiss()
        })
            .buttonStyle(BorderedProminentButtonStyle())
    }
}

#Preview {
    CustomLocationPickerView(viewModel: LocationListViewModel(networkService: NetworkManager()))
}