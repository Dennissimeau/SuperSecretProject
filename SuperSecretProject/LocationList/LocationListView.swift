//
//  ContentView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 27/04/2024.
//

import SwiftUI
import CoreLocation
import MapKit
import TipKit

struct LocationListView: View {
    @State var viewModel = LocationListViewModel(
        networkService: NetworkManager()
    )
    
    @State var showBottomSheet: Bool = false
    @State var selectedPickerIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                if selectedPickerIndex == 1 {
                    ItemGridView(locations: viewModel.locations) { lat, long in
                        openWikipedia(lat: lat, long: long)
                    }
                    
                } else {
                    ItemListView(locations: viewModel.locations) { lat, long in
                        openWikipedia(lat: lat, long: long)
                    }
                }
            }
            .animation(.smooth, value: selectedPickerIndex)
            .navigationTitle("Locations")
            .overlay {
                if viewModel.locations.isEmpty {
                    emptyViewOverlay
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    fetchLocationButton
                }
                if !viewModel.locations.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        locationsPicker
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    addCustomLocationButton
                }
            }
            .sheet(isPresented: $showBottomSheet) {
                CustomLocationPickerView(viewModel: viewModel)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    @ViewBuilder private var emptyViewOverlay: some View {
        switch viewModel.loadState {
        case .start:
            ContentUnavailableView("No locations yet!", systemImage: "location", description: Text("Tap fetch to get a list of locations and/or add one yourself."))
        case .error(let errorMessage):
            ContentUnavailableView("Something went wrong: \n \(errorMessage)", systemImage: "exclamationmark.triangle.fill")
        case .loading:
            ProgressView()
        case .retrieved:
            EmptyView()
        }
    }
    
    private var fetchLocationButton: some View {
        Button(action: {
            Task {
                await viewModel.fetchLocations()
            }
        }, label: {
            Text("Fetch")
        })
        .disabled(viewModel.locations.contains(where: { $0.isUserAdded == nil }))
    }
    
    private var addCustomLocationButton: some View {
        Button(action: {
            showBottomSheet = true
        }) {
            Image(systemName: "location.magnifyingglass")
                .foregroundStyle(.white)
                .padding(4)
                .background(
                    Color.blue
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                )
        }
    }
    
    private var locationsPicker: some View {
        Picker("", selection: $selectedPickerIndex) {
            Image(systemName: "list.bullet").tag(0)
            Image(systemName: "rectangle.grid.2x2").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private func openWikipedia(lat: Double, long: Double) {
        let urlString = "wikipedia://places?lat=\(String(lat))&lon=\(String(long))"
        guard let url = URL(string: urlString) else {
            print("invalid URL")
            return
        }
        UIApplication.shared.open(url)
    }
}

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
                .accessibilityAction(named: "Open in Wikipedia") {
                    openWikipedia(location.lat, location.long)
                }
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
                Text(String(location.lat))
                Text(String(location.long))
                Spacer()
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Coordinates: Latitude \(location.lat), Longitude \(location.long)")
        }
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    LocationListView()
}
