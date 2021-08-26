//
//  Song+CoreDataProperties.swift
//  Song
//
//  Created by Saruggan Thiruchelvan on 2021-08-26.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var file: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isExplicit: Bool
    @NSManaged public var title: String?
    @NSManaged public var artwork: String?
    @NSManaged public var album: Album?
    @NSManaged public var artist: Artist?
    @NSManaged public var playlists: Playlist?

}

extension Song : Identifiable {

}
