//
//  ContentView.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/13/23.
//

import SwiftUI
import CoreData
import MapKit
// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: AppViewModel
    
    @State private var selectedLocation: CLLocationCoordinate2D?
    
    
    var body: some View { //tabView used throughout the app with 4 different tabs 
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            WorkoutLogView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Workout Log")
                }

            PlacesListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
        }
    }
}



#Preview {
    ContentView(viewModel: AppViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
