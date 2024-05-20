//
//  ClassProjFinalApp.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/13/23.
//

import SwiftUI

@main
struct ClassProjFinalApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: AppViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
