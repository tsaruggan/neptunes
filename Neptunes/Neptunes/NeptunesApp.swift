//
//  NeptunesApp.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-03-27.
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
