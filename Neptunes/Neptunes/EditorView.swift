//
//  EditorView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-03.
//

import SwiftUI

struct EditorView: View {
    
    @ObservedObject public var viewModel: EditorViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    var fileManager = LocalFileManager()
    
    var body: some View {
        Form {
            Section(header: Text("Metadata")) {
                LabeledContent {
                    TextField("", text: $viewModel.currentTitle)
                } label: {
                    Text("Song Title:")
                }
                
                LabeledContent {
                    TextField("", text: $viewModel.currentAlbumName)
                } label: {
                    Text("Album Title:")
                }
                
                LabeledContent {
                    TextField("", text: $viewModel.currentArtist)
                } label: {
                    Text("Artist Title:")
                }
                
                if let artwork = $viewModel.currentArtwork.wrappedValue {
                    Image(uiImage: UIImage(data: artwork)!)
                } else {
                    Image(systemName: "photo.fill")
                }
            }
        }
        .onSubmit(of: .text, {
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
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        })
    }
}

final class EditorViewModel: ObservableObject {
    @Published var currentTitle: String
    @Published var currentAlbumName: String
    @Published var currentArtist: String
    @Published var currentArtwork: Data?
    @Published var currentURL: URL?

    init(metadata: Metadata) {
        currentTitle = metadata.title ?? "No title found!"
        currentArtist = metadata.artist ?? "No artist found!"
        currentAlbumName = metadata.albumName ?? "No album found!"
        currentArtwork = metadata.artwork
        currentURL = metadata.url
    }
    
}
