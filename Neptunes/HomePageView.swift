//
//  HomePageView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-06-27.
//

import SwiftUI
import CoreData

class HomePageViewModel: ObservableObject {
    @Published var reccomendations: [Collectable] = []
    
    var dataManager = CoreDataManager()
    var fileManager = LocalFileManager()
    
    init() {
        reccomendations = dataManager.fetchReccomendations()
        
        if reccomendations.isEmpty {
            initializeData()
            reccomendations = dataManager.fetchReccomendations()
        }
    }
    
    func initializeData() {
        let songID1 = UUID()
        let songFile1 = "song1"
        let audioURI1 = fileManager.saveAudio(file: songFile1, id: songID1)!
        let song1 = dataManager.initializeSong(title: "Not Around", audioURI: audioURI1, id: songID1, isExplicit: true)

        let songID2 = UUID()
        let songFile2 = "song2"
        let audioURI2 = fileManager.saveAudio(file: songFile2, id: songID2)!
        let song2 = dataManager.initializeSong(title: "Hell of a Night", audioURI: audioURI2, id: songID2, isExplicit: true)

        let songID3 = UUID()
        let songFile3 = "song3"
        let audioURI3 = fileManager.saveAudio(file: songFile3, id: songID3)!
        let song3 = dataManager.initializeSong(title: "Wither", audioURI: audioURI3, id: songID3)
        

        let albumID1 = UUID()
        let artworkURI1 = fileManager.saveArtwork(file: "drake_album_art_2", id: albumID1)
        let album1 = dataManager.initializeAlbum(title: "Not Around", id: albumID1, artworkURI: artworkURI1, isSingle: true)
        album1.addToSongs([song1, song2, song3])

        let artistID1 = UUID()
        let artworkURI2 = fileManager.saveArtwork(file: "drake_artist_art", id: artistID1)
        let artist1 = dataManager.initializeArtist(title: "Drake", id: artistID1, artworkURI: artworkURI2)
        artist1.addToSongs([song1, song2, song3])
        artist1.addToAlbums(album1)

        dataManager.saveData()
    }
    func mockup2() {
        let songIDs = Array(repeating: UUID(), count: 10)

        let songFile = "song3"
        let audioURI = fileManager.saveAudio(file: songFile, id: songIDs[0])!
        
        let song1 = dataManager.initializeSong(title: "Street Fighter", audioURI: audioURI, id: songIDs[0])
        let song2 = dataManager.initializeSong(title: "Strawberry Swing", audioURI: audioURI, id: songIDs[1])
        let song3 = dataManager.initializeSong(title: "Novacane", audioURI: audioURI, id: songIDs[2], isExplicit: true)
        let song4 = dataManager.initializeSong(title: "We All Try", audioURI: audioURI, id: songIDs[3])
        let song5 = dataManager.initializeSong(title: "Bitches Talkin'", audioURI: audioURI, id: songIDs[4])
        let song6 = dataManager.initializeSong(title: "Songs for Women", audioURI: audioURI, id: songIDs[5], isExplicit: true)
        let song7 = dataManager.initializeSong(title: "Lovecrimes", audioURI: audioURI, id: songIDs[6])
        let song8 = dataManager.initializeSong(title: "Goldeneye", audioURI: audioURI, id: songIDs[7])
        let song9 = dataManager.initializeSong(title: "There Will Be Tears", audioURI: audioURI, id: songIDs[8])
        let song10 = dataManager.initializeSong(title: "Swim Good", audioURI: audioURI, id: songIDs[9])
        
        let albumID = UUID()
        let artworkURI = fileManager.saveArtwork(file: "frank_ocean_album_art_2", id: albumID)
        let headerURI = fileManager.saveHeader(file: "frank_ocean_header_art_2", id: albumID)
        let album = dataManager.initializeAlbum(title: "nostalgia, ULTRA.", id: albumID, artworkURI: artworkURI, headerURI: headerURI)
        album.addToSongs([song1, song2, song3, song4, song5, song6, song7, song8, song9, song10])
        
        let artistID = UUID()
        let artistArtworkURI = fileManager.saveArtwork(file: "frank_ocean_artist_art", id: artistID)
        let artist = dataManager.initializeArtist(title: "Frank Ocean", id: artistID, artworkURI: artistArtworkURI)
        artist.addToSongs([song1, song2, song3, song4, song5, song6, song7, song8, song9, song10])
        artist.addToAlbums(album)
    }
    
    func mockup() {
        let songID = UUID()
        let songFile = "song5"
        let audioURI = fileManager.saveAudio(file: songFile, id: songID)!
        
        let song1 = dataManager.initializeSong(title: "Hell of a Night", audioURI: audioURI, id: songID, isExplicit: true)
        let song2 = dataManager.initializeSong(title: "Drugs You Should Try It", audioURI: audioURI, id: songID, isExplicit: false)
        let song3 = dataManager.initializeSong(title: "Skyfall (feat. Young Thug)", audioURI: audioURI, id: songID)
    
        let albumID1 = UUID()
        let artworkURI1 = fileManager.saveArtwork(file: "travis_scott_album_art_1", id: albumID1)
        let album1 = dataManager.initializeAlbum(title: "Owl Pharaoh", id: albumID1, artworkURI: artworkURI1)
        album1.addToSongs(song1)
        
        let albumID2 = UUID()
        let artworkURI2 = fileManager.saveArtwork(file: "travis_scott_album_art_2", id: albumID2)
        let album2 = dataManager.initializeAlbum(title: "Days Before Rodeo", id: albumID2, artworkURI: artworkURI2)
        album2.addToSongs([song2, song3])
        
        let artistID = UUID()
        let artworkURI = fileManager.saveArtwork(file: "travis_scott_artist_art", id: artistID)
        let headerURI = fileManager.saveHeader(file: "travis_scott_header_art", id: artistID)
        let artist = dataManager.initializeArtist(title: "Travis Scott", id: artistID, artworkURI: artworkURI, headerURI: headerURI)
        artist.addToSongs([song1, song2, song3])
        artist.addToAlbums([album1, album2])
        
        
    }
    
    func initializeDemoData() {
        let songID1 = UUID()
        let songFile1 = "song5"
        let audioURI1 = fileManager.saveAudio(file: songFile1, id: songID1)!
        let song1 = dataManager.initializeSong(title: "Cancun", audioURI: audioURI1, id: songID1, isExplicit: true)
        
        let albumID1 = UUID()
        let artworkURI1 = fileManager.saveArtwork(file: "playboi_carti_album_art_1", id: albumID1)
        let album1 = dataManager.initializeAlbum(title: "Not Around", id: albumID1, artworkURI: artworkURI1, isSingle: true)
        album1.addToSongs(song1)
        
        let artistID1 = UUID()
        let artist1 = dataManager.initializeArtist(title: "Playboi Carti", id: artistID1)
        artist1.addToSongs(song1)
        artist1.addToAlbums(album1)
    }
}

struct HomePageView: View {
    @ObservedObject var viewModel: HomePageViewModel = HomePageViewModel()
    
    init() {
        //        UITableView.appearance().backgroundColor = .clear
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
            ForEach(viewModel.reccomendations, id: \.self.id) { reccomendation in
                if let album = reccomendation as? Album {
                    CollectableItemView(title: album.title, subheading: album.artist.title, artworkURI: album.artworkURI) {
                        AlbumView(viewModel: .init(album: album))
                    }
                    
                } else if let playlist = reccomendation as? Playlist {
                    CollectableItemView(title: playlist.title, subheading: "Playlist", artworkURI: playlist.artworkURI) {
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
    var artworkURI: URL?
    let view: CollectableView
    
    init(title: String, subheading: String, artworkURI: URL?, @ViewBuilder view: () -> CollectableView) {
        self.title = title
        self.subheading = subheading
        self.artworkURI = artworkURI
        self.view = view()
    }
    
    var body: some View {
        NavigationLink(destination: view) {
            VStack(alignment: .leading) {
                Image(imageURI: artworkURI, default: "default_album_art")
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
