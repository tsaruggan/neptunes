//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-03-27.
//

import SwiftUI
import CoreData
import AVFoundation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
        animation: .default)
    private var songs: FetchedResults<Song>
    
    var fileManager = LocalFileManager()
    var player: AVPlayer = AVPlayer()
    
    @State private var showingEditor = false
    @State private var showingImporter = false
    
    @State var currentURL: URL? = nil
    @State var currentMetadata: Metadata? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(songs) { song in
                    VStack {
                        Text(song.title!)
                        Image(uiImage: UIImage(data: song.album!.coverArtwork!)!)
                    }
                    .onTapGesture {
                        let url = fileManager.retrieveSong(song: song)
                        play(url: url!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        showingImporter = true
                    } label: {
                        Label("Add Song", systemImage: "plus")
                    }
                }
            }
        }
        .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.mp3], onCompletion: { result in
            switch result {
            case .success(let url):
                print(url)
                currentURL = url
                
                Task {
                    currentMetadata = await Metadata.getMetadata(for: url)
                }
                
                showingEditor = true
            case .failure(let error):
                print(error)
            }
        })
        .sheet(isPresented: $showingEditor) {
            Form {
                Section(header: Text("Song Information")) {
                    Text(currentMetadata?.title ?? "No title.")
                }
            }
        }
    }
    
    private func addItem() {
        showingEditor = true
        
        // create Song from mp3 file
//        Task {
//            let filename = "01 Nikes"
//            let url = Bundle.main.url(forResource: filename, withExtension: "mp3")!
//            let metadata = await Metadata.getMetadata(for: url)
//
//            let newArtist = Artist(context: viewContext)
//            newArtist.title = metadata.artist
//
//            let newAlbum = Album(context: viewContext)
//            newAlbum.artist = newArtist
//            newAlbum.coverArtwork = metadata.artwork
//
//            let newSong = Song(context: viewContext)
//            newSong.title = metadata.title
//            newSong.album = newAlbum
//            newSong.artist = newArtist
//            newSong.id = UUID()
//
//            fileManager.saveSong(filename: filename, song: newSong)
//
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { songs[$0] }.forEach(viewContext.delete)
            
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
    
    func play(url: URL) {
        print("playing \(url)")
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
