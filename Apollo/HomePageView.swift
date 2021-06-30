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
    let images: [String] = [
        "drake_album_art_1",
        "frank_ocean_album_art_1",
        "drake_artist_art",
        "travis_scott_album_art_1",
        "frank_ocean_artist_art",
        "travis_scott_album_art_2",
        "travis_scott_artist_art"
    ]
    
    let albums: [Album] = [
        Album(album: "Not Around", artist: "Drake", image: "drake_album_art_1"),
        Album(album: "Endless", artist: "Frank Ocean", image: "frank_ocean_album_art_1"),
        Album(album: "Toosie Slide", artist: "Drake", image: "drake_artist_art"),
        Album(album: "Owl Pharaoh", artist: "Travis Scott", image: "travis_scott_album_art_1"),
        Album(album: "Boys Don't Cry", artist: "Frank Ocean", image: "frank_ocean_artist_art"),
        Album(album: "Days Before Rodeo", artist: "Travis Scott", image: "travis_scott_album_art_2"),
        Album(album: "Unreleased", artist: "Travis Scott", image: "travis_scott_artist_art"),
        Album(album: "Not Around", artist: "Drake", image: "drake_album_art_1"),
        Album(album: "Endless", artist: "Frank Ocean", image: "frank_ocean_album_art_1"),
        Album(album: "Toosie Slide", artist: "Drake", image: "drake_artist_art")
    ]
    
    let bg: Color = Color(red: 24/255, green: 24/255, blue: 24/255)
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            bg.ignoresSafeArea()
            ScrollView {
                VStack {
                    HStack {
                        Text(Date(), style: .time)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.green)
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
                            VStack(alignment: .leading) {
                                Image(album.image)
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(5)
                                Text(album.album)
                                    .fontWeight(.bold)
                                Text(album.artist)
                            }
                            .foregroundColor(.white)
                            .padding(5)
                        }
                    }
                }
                .padding()
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
