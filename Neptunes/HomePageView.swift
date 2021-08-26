//
//  HomePageView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-06-27.
//

import SwiftUI
import CoreData

class HomePageViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var reccomendations: [Collectable] = []
    
    init() {
        container = NSPersistentContainer(name: "NeptunesContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error)
            }
        }
        fetchReccomendations()
        
        if self.reccomendations.isEmpty {
            initializeReccomendations()
        }
    }
    
    func fetchReccomendations() {
        let albumsRequest = NSFetchRequest<Album>(entityName: "Album")
        let playlistsRequest = NSFetchRequest<Playlist>(entityName: "Playlist")
        do {
            self.reccomendations = try container.viewContext.fetch(albumsRequest)
            self.reccomendations += try container.viewContext.fetch(playlistsRequest)
        } catch let error {
            print(error)
        }
    }
    
    func initializeReccomendations() {
        let albumArtwork = "drake_album_art_2"
        let artistArtwork = "drake_artist_art"
        
        let song = Song(context: container.viewContext)
        song.title = "Not Around"
        song.isExplicit = false
        song.file = "song1"
        song.artwork = albumArtwork
        song.id = UUID()
        
        let album = Album(context: container.viewContext)
        album.title = "Not Around"
        album.artwork = albumArtwork
        album.id = UUID()
        album.addToSongs(song)
        
        let artist = Artist(context: container.viewContext)
        artist.title = "Drake"
        artist.artwork = artistArtwork
        artist.id = UUID()
        artist.addToSongs(song)
        album.artist = artist
        
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchReccomendations()
        } catch let error {
            print("An error occurred while saving. \(error)")
        }
    }
}

struct HomePageView: View {
    @ObservedObject var viewModel: HomePageViewModel = HomePageViewModel()
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().isTranslucent = true
//        UITabBar.appearance().backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
    }
    
    var header: some View {
        HStack {
            Text(Date(), style: .time)
                .foregroundColor(.primary)
                .fontWeight(.bold)
            Spacer()
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .foregroundColor(.teal)
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
    
    var finderList: some View {
        Group {
            Divider().background(Color.secondary)
            FinderListItemView(text: "Songs", icon: "music.note", emoji: "🎸") { SongFinderView() }
            Divider().background(Color.secondary)
            FinderListItemView(text: "Artists", icon: "music.mic", emoji: "🎤") { ArtistFinderView() }
            Divider().background(Color.secondary)
            FinderListItemView(text: "Albums", icon: "square.stack", emoji: "💽") { AlbumFinderView() }
            Divider().background(Color.secondary)
            FinderListItemView(text: "Playlists", icon: "music.note.list", emoji: "🎵") { PlaylistFinderView() }
            Divider().background(Color.secondary)
        }
    }
    
    var collectableGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(viewModel.reccomendations.map({ CollectableWrapper($0) })) { anyCollectable in
                let collectable = anyCollectable.collectable
                if let album = collectable as? Album {
                    CollectableItemView(title: album.title!, subheading: album.artist!.title!, artwork: album.artwork) {
                        AlbumView(viewModel: .init(album: album))
                    }
                    
                } else if let playlist = collectable as? Playlist {
                    CollectableItemView(title: playlist.title!, subheading: "Playlist", artwork: playlist.artwork!) {
                        PlaylistView(viewModel: .init(playlist: playlist))
                    }
                }
            }
        }
    }
    
    var content: some View {
        VStack {
            header
            finderList
            collectableGrid
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            content
                .padding()
                .padding(.bottom, 80)
                .navigationBarHidden(true)
        }
        .padding(.top)
    }
}


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

struct CollectableItemView<CollectableView: View>: View {
    var title: String
    var subheading: String
    var artwork: String?
    let view: CollectableView
    
    init(title: String, subheading: String, artwork: String?, @ViewBuilder view: () -> CollectableView) {
        self.title = title
        self.subheading = subheading
        self.artwork = artwork
        self.view = view()
    }
    
    var body: some View {
        NavigationLink(destination: view) {
            VStack(alignment: .leading) {
                Image(artwork ?? "default_album_art")
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(8)
                Text(title)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text(subheading)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(5)
        }
    }
}

struct FinderListItemView<Destination: View>: View {
    var text: String
    var icon: String
    var emoji: String
    var destination: Destination
    
    init(text: String, icon: String, emoji: String, @ViewBuilder destination: () -> Destination) {
        self.text = text
        self.icon = icon
        self.emoji = emoji
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .firstTextBaseline) {
                Text(emoji)
//                Image(systemName: icon)
//                    .foregroundColor(.teal)
                Text(text)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
    }
}
