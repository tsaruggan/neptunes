//
//  Song+CoreDataProperties.swift
//  Song
//
//  Created by Saruggan Thiruchelvan on 2021-09-06.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var audioURI: URL
    @NSManaged public var id: UUID
    @NSManaged public var isExplicit: Bool
    @NSManaged public var title: String
    @NSManaged public var album: Album
    @NSManaged public var artist: Artist
    @NSManaged public var playlists: NSSet?

}

// MARK: Generated accessors for playlists
extension Song {

    @objc(addPlaylistsObject:)
    @NSManaged public func addToPlaylists(_ value: Playlist)

    @objc(removePlaylistsObject:)
    @NSManaged public func removeFromPlaylists(_ value: Playlist)

    @objc(addPlaylists:)
    @NSManaged public func addToPlaylists(_ values: NSSet)

    @objc(removePlaylists:)
    @NSManaged public func removeFromPlaylists(_ values: NSSet)

}

extension Song : Identifiable {

}
