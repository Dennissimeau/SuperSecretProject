//
//  ContentView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 27/04/2024.
//

import SwiftUI

struct LocationListView: View {
    @State var viewModel = LocationListViewModel(
        networkService: NetworkManager()
    )
    
    @State var showBottomSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.locations, id: \.self) { location in
                LocationItemView(location: location)
                .onTapGesture {
                    openWikipedia(lat: location.lat, long: location.long)
                }
            }
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
            ContentUnavailableView("Fetch locations", systemImage: "location")
        case .error(let errorMessage):
            ContentUnavailableView("Something went wrong: \n \(errorMessage.localizedDescription)", systemImage: "location")
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
    
    private func openWikipedia(lat: Double, long: Double) {
        let urlString = "wikipedia://places?lat=\(String(lat))&lon=\(String(long))"
        guard let url = URL(string: urlString) else {
            print("invalid URL")
            return
        }
        UIApplication.shared.open(url)
    }
}

struct LocationItemView: View {
    var location: Location
    
    var body: some View {
        VStack(alignment: .leading) {
            if let name = location.name {
                Text(name)
                    .bold()
            }
            HStack {
                Text(String(location.lat))
                Text(String(location.long))
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    LocationListView()
}
