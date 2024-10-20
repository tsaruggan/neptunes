//
//  ArtistEditorViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-13.
//

import Foundation
import CoreData
import SwiftUI
import AVFoundation
import PhotosUI

final class ArtistEditorViewModel: ObservableObject {
    var editorAction: EditorActionType
    
    var viewContext: NSManagedObjectContext
    var dataManager: CoreDataManager
    var fileManager: LocalFileManager = LocalFileManager.shared
    
    
    @Published var artistTitle: String = ""
    @Published var artistCoverArtwork: UIImage? = nil
    @Published var artistHeaderArtwork: UIImage? = nil
    var artistColorPalette: ColorPalette? = nil
    @Published var currentArtist: Artist? = nil
    
    @Published var audioPlayer: AVPlayer?
    @Published var isPlaying: Bool = false
    
    init(artist: Artist, viewContext: NSManagedObjectContext) {
        self.currentArtist = artist
        self.artistTitle = artist.title
        self.artistCoverArtwork = artist.coverArtwork?.asUIImage
        self.artistHeaderArtwork = artist.headerArtwork?.asUIImage
        self.artistColorPalette = artist.palette?.toColorPalette()
        
        self.viewContext = viewContext
        self.dataManager = CoreDataManager(viewContext: viewContext)
        self.editorAction = .edit
    }

    func updateArtist() {
        dataManager.updateArtist(artist: currentArtist!, title: artistTitle, coverArtwork: artistCoverArtwork, headerArtwork: artistHeaderArtwork, palette: artistColorPalette)
        objectWillChange.send()
    }
    
    func deleteArtist() {
        fileManager.deleteArtist(artist: currentArtist!)
        dataManager.deleteArtist(artist: currentArtist!)
    }
    
    func onArtistArtworkChange() {
        Task {
            artistColorPalette = ColorAnalyzer.generatePalette(coverArtwork: artistCoverArtwork, headerArtwork: artistHeaderArtwork)
        }
    }
    
    func validate() -> Bool {
        let artistExists = artistTitle != ""
        return artistExists
    }
}
