//
//  FinderViewModel.swift
//  FinderViewModel
//
//  Created by Saruggan Thiruchelvan on 2021-08-28.
//

import Foundation
import CoreData

class FinderViewModel<T: NSFetchRequestResult>: ObservableObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NeptunesContainer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    @Published var findables: [T] = []
    
    init(entityName: String) {
        let request = NSFetchRequest<T>(entityName: entityName)
        do {
            self.findables = try self.persistentContainer.viewContext.fetch(request)
        } catch let error {
            print(error)
        }
    }
}
