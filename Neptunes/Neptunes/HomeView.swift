//
//  HomeView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-07-28.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
    //        animation: .default)
    //    private var songs: FetchedResults<Song>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Album.title, ascending: true)],
        animation: .default)
    private var albums: FetchedResults<Album>
    
    @State private var presentingSongEditor = false
    @State private var presentingSongImporter = false
    @State private var currentMetadata = Metadata()
    
    var body: some View {
        
        VStack {
            Group {
                NavigationLink("Songs") {
                    SongFinderView(viewContext: viewContext)
                }
                NavigationLink("Albums") {
                    AlbumFinderView(viewContext: viewContext)
                }
                NavigationLink("Artists") {
                    ArtistFinderView(viewContext: viewContext)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    presentingSongImporter = true
                } label: {
                    Label("Add Song", systemImage: "plus")
                }
            }
        }
        .fileImporter(isPresented: $presentingSongImporter, allowedContentTypes: [.mp3], onCompletion: { result in
            switch result {
            case .success(let url):
                guard url.startAccessingSecurityScopedResource() else {
                    return
                }
                
                Task {
                    currentMetadata = await Metadata.getMetadata(for: url)
                }
                presentingSongEditor = true
            case .failure(let error):
                print(error)
            }
        })
        .sheet(isPresented: $presentingSongEditor) {
            SongEditorView(
                viewModel: SongEditorViewModel(metadata: currentMetadata, viewContext: viewContext),
                presentingEditor: $presentingSongEditor
            )
        }
        
    }
    
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { songs[$0] }.forEach(viewContext.delete)
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

