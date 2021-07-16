//
//  HomePageView.swift
//  Neptunes
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
    let model = MusicModel()
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Text(Date(), style: .time)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.teal)
                        
                    }
                    
                    ForEach(items) { item in
                        Divider()
                            .background(Color.secondary)
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundColor(.teal)
                            Text(item.name)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        .listRowInsets(EdgeInsets())
                    }
                    Divider()
                        .background(Color.secondary)
                    
                    
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(model.collectables.map({ CollectableWrapper($0) })) { anyCollectable in
                            let collectable = anyCollectable.collectable
                            if let album = collectable as? Album {
                                CollectableItemView(title: album.title, subheading: album.artist.title, artwork: album.artwork) {
                                    AlbumView(viewModel: .init(album: album))
                                }
                                
                            } else if let playlist = collectable as? Playlist {
                                CollectableItemView(title: playlist.title, subheading: "Playlist", artwork: playlist.artwork) {
                                    PlaylistView(viewModel: .init(playlist: playlist))
                                }
                            }
                        }
                    }
                }
                .padding()
                .navigationBarHidden(true)
                .navigationBarTitle("")
            }
            .padding(.top)
        }
        .overlay(NowPlayingBar(), alignment: .bottom)
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
        NavigationLink {
            view
        } label: {
            VStack(alignment: .leading) {
                Image(artwork ?? "default_album_art")
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
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
