//
//  Artist+CoreDataProperties.swift
//  Artist
//
//  Created by Saruggan Thiruchelvan on 2021-09-06.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var artworkURI: URL?
    @NSManaged public var headerURI: URL?
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var albums: NSSet
    @NSManaged public var songs: NSSet

}

// MARK: Generated accessors for albums
extension Artist {

    @objc(addAlbumsObject:)
    @NSManaged public func addToAlbums(_ value: Album)

    @objc(removeAlbumsObject:)
    @NSManaged public func removeFromAlbums(_ value: Album)

    @objc(addAlbums:)
    @NSManaged public func addToAlbums(_ values: NSSet)

    @objc(removeAlbums:)
    @NSManaged public func removeFromAlbums(_ values: NSSet)

}

// MARK: Generated accessors for songs
extension Artist {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}

extension Artist : Identifiable {

}
