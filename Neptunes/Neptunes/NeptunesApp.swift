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
    let dataManager: CoreDataManager
    
    init() {
        self.dataManager = CoreDataManager(viewContext: persistenceController.container.viewContext)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
