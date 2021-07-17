//
//  HomePageView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-06-27.
//

import SwiftUI

struct HomePageView: View {
    let items = [
        (name: "Songs", icon: "music.note"),
        (name: "Artists", icon: "music.mic"),
        (name: "Albums", icon: "square.stack"),
        (name: "Playlists", icon: "music.note.list")
    ]
    let model = MusicModel()
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
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
    
    var selectionList: some View {
        Group{
            ForEach(items.indices, id: \.self) { index in
                Divider()
                    .background(Color.secondary)
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: items[index].icon)
                        .foregroundColor(.teal)
                    Text(items[index].name)
                        .foregroundColor(.primary)
                    Spacer()
                    
                }
                .listRowInsets(EdgeInsets())
            }
            Divider()
                .background(Color.secondary)
        }
    }
    
    var collectableGrid: some View {
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
    
    var content: some View {
        VStack {
            header
            selectionList
            collectableGrid
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                content
                    .padding()
                    .padding(.bottom, 80)
                    .navigationBarHidden(true)
            }
            .padding(.top)
        }
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
        NavigationLink {
            view
        } label: {
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
