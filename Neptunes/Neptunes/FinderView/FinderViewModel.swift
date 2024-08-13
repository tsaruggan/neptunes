//
//  FinderViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-08-28.
//

import Foundation
import CoreData

class FinderViewModel<T: NSFetchRequestResult>: ObservableObject {
    @Published var findables: [T] = []
    private var viewContext: NSManagedObjectContext
    private var entityName: String

    init(entityName: String, viewContext: NSManagedObjectContext) {
        self.entityName = entityName
        self.viewContext = viewContext
        fetchFindables()
        addCoreDataObservers()
    }
    
    private func fetchFindables() {
        let request = NSFetchRequest<T>(entityName: entityName)
        do {
            self.findables = try viewContext.fetch(request)
        } catch let error {
            print(error)
        }
    }
    
    private func addCoreDataObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectsDidChange(_:)),
            name: .NSManagedObjectContextObjectsDidChange,
            object: viewContext
        )
    }
    
    @objc private func contextObjectsDidChange(_ notification: Notification) {
        fetchFindables()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
