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
    var fileManager: LocalFileManager = LocalFileManager()
    
    
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
        let artist = currentArtist!
        artist.title = artistTitle
        artist.coverArtwork = artistCoverArtwork?.pngData()
        artist.headerArtwork = artistHeaderArtwork?.pngData()
        if let oldPalette = artist.palette {
            viewContext.delete(oldPalette)
        }
        artist.palette = dataManager.initializePalette(colorPalette: artistColorPalette)
        
        dataManager.saveData()
        objectWillChange.send()
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