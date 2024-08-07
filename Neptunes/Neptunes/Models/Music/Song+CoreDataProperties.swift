//
//  Song+CoreDataProperties.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-06.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var isExplicit: Bool
    @NSManaged public var album: Album
    @NSManaged public var artist: Artist

}

extension Song : Identifiable {

}
