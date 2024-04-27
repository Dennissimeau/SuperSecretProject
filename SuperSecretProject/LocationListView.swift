//
//  ContentView.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 27/04/2024.
//

import SwiftUI
import CoreLocation

struct Location: Hashable {
    let name: String?
    let latitude: Double
    let longitude: Double
    
    static var sampleLocations: [Self] {
        return [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468),
            Location(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785),
            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ]
    }
}

struct LocationListView: View {
    
    let locations = Location.sampleLocations
    @State var showBottomSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List(locations, id: \.self) { location in
                VStack(alignment: .leading) {
                    if let name = location.name {
                        Text(name)
                            .bold()
                    }
                    HStack {
                        Text(String(location.latitude))
                        Text(String(location.longitude))
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                }
            }
            .navigationTitle("Locations")
            .toolbar(content: {
                Button(action: {
                    showBottomSheet = true
                }) {
                    Image(systemName: "location.magnifyingglass")
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(Color.blue
                            .clipShape(RoundedRectangle(cornerRadius: 8)))
                }
            })
            .sheet(isPresented: $showBottomSheet) {
                CustomLocationPickerView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct CustomLocationPickerView: View {
    var body: some View {
        Text("PickerView")
    }
}

#Preview {
    LocationListView()
}
