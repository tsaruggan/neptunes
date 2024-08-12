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
    
    init(entityName: String, viewContext: NSManagedObjectContext) {
        let request = NSFetchRequest<T>(entityName: entityName)
        do {
            self.findables = try viewContext.fetch(request)
        } catch let error {
            print(error)
        }
    }
}
