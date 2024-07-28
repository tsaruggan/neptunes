//
//  Metadata.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-02.
//

import Foundation
import AVFoundation

struct Metadata {
    var songTitle: String?
    var albumTitle: String?
    var albumCoverArtwork: Data?
    var artistTitle: String?
    var url: URL?
    
    init(titleItem: AVMetadataItem?, artistItem: AVMetadataItem?, albumNameItem: AVMetadataItem?, artworkItem: AVMetadataItem?, url: URL?) async {
        do {
            songTitle = try await titleItem?.load(.stringValue)
            artistTitle = try await artistItem?.load(.stringValue)
            albumTitle = try await albumNameItem?.load(.stringValue)
            albumCoverArtwork = try await artworkItem?.load(.dataValue)
            self.url = url
        } catch {
            print(error)
        }
    }
    
    init() {
        songTitle = nil
        artistTitle = nil
        albumTitle = nil
        albumCoverArtwork = nil
        url = nil
    }

    static func getMetadata(for url: URL) async -> Metadata {
        let asset = AVAsset(url: url)
        var metadata = [AVMetadataItem]()
        do {
            metadata = try await asset.loadMetadata(for: .id3Metadata)
        } catch {
            print(error)
        }
        let titleItem = getMetadataItem(metadata: metadata, identifier: .commonIdentifierTitle)
        let artistItem = getMetadataItem(metadata: metadata, identifier: .commonIdentifierArtist)
        let albumNameItem = getMetadataItem(metadata: metadata, identifier: .commonIdentifierAlbumName)
        let artworkItem = getMetadataItem(metadata: metadata, identifier: .commonIdentifierArtwork)
        
        return await Metadata(titleItem: titleItem,
                              artistItem: artistItem,
                              albumNameItem: albumNameItem,
                              artworkItem: artworkItem,
                              url: url)
    }
    
    static func getMetadataItem(metadata: [AVMetadataItem], identifier: AVMetadataIdentifier) -> AVMetadataItem? {
        return AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: identifier).first
    }
}
