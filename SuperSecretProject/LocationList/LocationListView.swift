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

    @State var showWikiErrorAlert: Bool = false
    @State var showBottomSheet: Bool = false
    @State var selectedPickerIndex: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.locations.isEmpty {
                    emptyViewOverlay
                } else {
                    if selectedPickerIndex == 1 {
                        ItemGridView(locations: viewModel.locations, openWikipedia: openWikipedia)

                    } else {
                        ItemListView(locations: viewModel.locations, openWikipedia: openWikipedia)
                    }
                }
            }
            .animation(.smooth, value: selectedPickerIndex)
            .navigationTitle("Locations")
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
            .alert(
                "Seems you don't have the Wikipedia app fork installed. Install it via Xcode and try again.",
                isPresented: $showWikiErrorAlert) { }
        }
    }

    @ViewBuilder private var emptyViewOverlay: some View {
        switch viewModel.loadState {
        case .start:
            ContentUnavailableView(
                "No locations yet!",
                systemImage: "location",
                description: Text("Tap fetch to get a list of locations and/or add one yourself.")
            )
        case .error(let errorMessage):
            ContentUnavailableView(
                "Something went wrong: \n \(errorMessage)",
                systemImage: "exclamationmark.triangle.fill"
            )
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
        .accessibilityHint("Fetches locations")
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
        .accessibilityHint("Opens modal to select a favorite location on the map")
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
        guard UIApplication.shared.canOpenURL(url) else {
            showWikiErrorAlert = true
            return
        }
        UIApplication.shared.open(url)
    }
}

#Preview {
    LocationListView()
}
