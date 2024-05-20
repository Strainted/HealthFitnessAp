//
//  PlacesListView.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/19/23.
//

import Foundation


import SwiftUI
import MapKit

struct PlacesListView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingAddPlaceSheet = false
    @State private var newPlaceName = ""
    @State private var newPlaceAddress = ""

    var body: some View {
        NavigationView {
            List(viewModel.places, id: \.name) { place in
                NavigationLink(destination: MapView(place: place)) {
                    Text(place.name)
                }
            }
            .navigationTitle("Places")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddPlaceSheet.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showingAddPlaceSheet) {
                    AddPlaceView(viewModel: viewModel, isPresented: $showingAddPlaceSheet, name: $newPlaceName, address: $newPlaceAddress)
                }
            )
        }
    }
}

struct MapView: View {
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    var place: Place
    @State private var selectedMapItem: SearchResult?
    
    var body: some View {
        VStack {
            // Search Bar
            CustomSearchBar(text: $searchText, onSearch: performSearch)
            
            // Map
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )), showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: searchResults) { item in
                MapPin(coordinate: item.coordinate, tint: .blue)
            }
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        // Handle map tap if needed
                    }
            )
            .onTapGesture {
                // Handle map tap if needed
            }
            .sheet(item: $selectedMapItem) { result in
                // Access result directly, no need for optional chaining
                let mapItem = result.mapItem
                
                // Present additional details or navigation when a map pin is tapped
                // You can customize this sheet based on your requirements
                Text("Details for \(mapItem.name ?? "Unknown")")
            }
            
        }
        .navigationTitle(place.name)
    }
    
    
    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard error == nil else {
                print("Search error: \(error!.localizedDescription)")
                return
            }
            
            if let response = response {
                // Clear previous search results
                searchResults = response.mapItems.map { SearchResult(mapItem: $0) }
            }
        }
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem

    var coordinate: CLLocationCoordinate2D {
        mapItem.placemark.coordinate
    }
}

struct CustomSearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                onSearch()
            }) {
                Text("Search")
            }
        }
        .padding(.horizontal)
    }
}

