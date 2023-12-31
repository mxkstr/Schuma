//
//  SchumaApp.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import SwiftUI
import SwiftData

@main
struct SchumaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LogLocation.self,
            LocationVisit.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(visitModel: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
}
