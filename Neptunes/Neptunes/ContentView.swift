//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-03-27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
        animation: .default)
    private var songs: FetchedResults<Song>
    
    @State private var presentingEditor = false
    @State private var presentingImporter = false
    @State private var currentMetadata = Metadata()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(songs) { song in
                    VStack {
                        Text(song.title ?? "No title found!").font(.headline)
                        Text(song.album?.title ?? "No album found!").font(.caption)
                        Text(song.artist?.title ?? "No artist found!").font(.subheadline)
                        
                        if let coverArtwork = song.album?.coverArtwork {
                            Image(uiImage: UIImage(data: coverArtwork)!)
                        } else {
                            Image(systemName: "photo.fill")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        presentingImporter = true
                    } label: {
                        Label("Add Song", systemImage: "plus")
                    }
                }
            }
        }
        .fileImporter(isPresented: $presentingImporter, allowedContentTypes: [.mp3], onCompletion: { result in
            switch result {
            case .success(let url):
                print(url)
                
                Task {
                    currentMetadata = await Metadata.getMetadata(for: url)
                }
                
                presentingEditor = true
            case .failure(let error):
                print(error)
            }
        })
        .sheet(isPresented: $presentingEditor) {
            EditorView(viewModel: EditorViewModel(metadata: currentMetadata))
        }
    }
    
    private func addItem() {
        presentingEditor = true
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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
