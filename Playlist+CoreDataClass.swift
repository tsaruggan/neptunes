//
//  Playlist+CoreDataClass.swift
//  Playlist
//
//  Created by Saruggan Thiruchelvan on 2021-08-25.
//
//

import Foundation
import CoreData

@objc(Playlist)
public class Playlist: NSManagedObject {

}

extension Playlist : Findable, Collectable  {
    var date: Date? {
        return nil
    }
    

}
