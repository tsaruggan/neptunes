//
//  HomePageView.swift
//  Apollo
//
//  Created by Saruggan Thiruchelvan on 2021-06-27.
//

import SwiftUI

struct HomePageView: View {
    let items: [Item] = [
        Item(name: "Songs", icon: "music.note"),
        Item(name: "Artists", icon: "music.mic"),
        Item(name: "Albums", icon: "square.stack"),
        Item(name: "Playlists", icon: "music.note.list")
    ]
    
    let albums: [Album] = [
        Album(album: "Not Around", artist: "Drake", image: "drake_album_art_1"),
        Album(album: "Endless", artist: "Frank Ocean", image: "frank_ocean_album_art_1"),
        Album(album: "SUMMER 2021", artist: "Playlist", image: "drake_artist_art"),
        Album(album: "Owl Pharaoh", artist: "Travis Scott", image: "travis_scott_album_art_1"),
        Album(album: "Boys Don't Cry", artist: "Playlist", image: "frank_ocean_artist_art"),
        Album(album: "Days Before Rodeo", artist: "Travis Scott", image: "travis_scott_album_art_2"),
        Album(album: "Travis Scott Unreleased", artist: "Playlist", image: "travis_scott_artist_art"),
        Album(album: "Not Around", artist: "Drake", image: "drake_album_art_1"),
        Album(album: "Endless", artist: "Frank Ocean", image: "frank_ocean_album_art_1"),
        Album(album: "Toosie Slide", artist: "Drake", image: "drake_artist_art")
    ]
    
    let bg: Color = Color(red: 24/255, green: 24/255, blue: 24/255)
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                bg.edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Text(Date(), style: .time)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Spacer()
                            if #available(iOS 15.0, *) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.teal)
                            }
                        }
                        
                        ForEach(items) { item in
                            Divider()
                                .background(Color.white)
                            HStack {
                                Label {
                                    Text(item.name)
                                } icon: {
                                    Image(systemName: item.icon)
                                }
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .listRowInsets(EdgeInsets())
                        }
                        Divider()
                            .background(Color.white)
                        
                        
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            ForEach(albums) { album in
                                AlbumItemView(album: album)
                            }
                        }
                    }
                }
                .padding()
                .navigationBarHidden(true)
                .navigationBarTitle("")
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

struct Item: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
}

struct Album: Identifiable {
    var id = UUID()
    var album: String
    var artist: String
    var image: String
}

struct AlbumItemView: View {
    var album: Album
    var body: some View {
        
        if #available(iOS 15.0, *) {
            NavigationLink {
                AlbumView(album: album)
            } label: {
                VStack(alignment: .leading) {
                    Image(album.image)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(5)
                    Text(album.album)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(album.artist)
                        .lineLimit(1)
                }
                .foregroundColor(.white)
                .padding(5)
            }
        }
    }
}
