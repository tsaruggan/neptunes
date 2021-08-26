//
//  Song+CoreDataClass.swift
//  Song
//
//  Created by Saruggan Thiruchelvan on 2021-08-25.
//
//

import Foundation
import CoreData

@objc(Song)
public class Song: NSManagedObject {
    
}

extension Song:  Findable {
    var date: Date? {
        return nil
    }
    

}
