//
//  NeptunesApp.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-07-23.
//

import SwiftUI

@main
struct NeptunesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
