//
//  EditorView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-03.
//

import SwiftUI

struct EditorView: View {
    
    @ObservedObject public var viewModel: EditorViewModel
    
    @Binding var presentingEditor: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    var fileManager = LocalFileManager()
    
    var body: some View {
        Form {
            Section(header: Text("Metadata")) {
                TextField("Title", text: $viewModel.currentTitle)
                TextField("Album", text: $viewModel.currentAlbumName)
                TextField("Artist", text: $viewModel.currentArtist)
            }

            Button("Submit") {
                let newArtist = Artist(context: viewContext)
                newArtist.title = viewModel.currentArtist
                
                let newAlbum = Album(context: viewContext)
                newAlbum.title = viewModel.currentAlbumName
                newAlbum.artist = newArtist
                newAlbum.coverArtwork = viewModel.currentArtwork
                
                let newSong = Song(context: viewContext)
                newSong.title = viewModel.currentTitle
                newSong.album = newAlbum
                newSong.artist = newArtist
                newSong.id = UUID()
                
                fileManager.saveSongFromURL(url: viewModel.currentURL!, song: newSong)
                presentingEditor = false
                
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

final class EditorViewModel: ObservableObject {
    @Published var currentTitle: String
    @Published var currentAlbumName: String
    @Published var currentArtist: String
    @Published var currentArtwork: Data?
    @Published var currentURL: URL?

    init(metadata: Metadata) {
        currentTitle = metadata.title ?? ""
        currentArtist = metadata.artist ?? ""
        currentAlbumName = metadata.albumName ?? ""
        currentArtwork = metadata.artwork
        currentURL = metadata.url
    }
    
}
