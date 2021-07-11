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
    let bg: Color = Color(red: 24/255, green: 24/255, blue: 24/255)
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
                        ForEach(model.albums) { album in
                            AlbumItemView(album: album)
                        }
                    }
                }
                .padding()
                .navigationBarHidden(true)
                .navigationBarTitle("")
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

struct Item: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
}

struct AlbumItemView: View {
    var album: Album
    var body: some View {
        NavigationLink {
            AlbumView(viewModel: .init(album: album))
        } label: {
            VStack(alignment: .leading) {
                Image(album.image)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
                Text(album.title)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text(album.artist.title)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            .padding(5)
        }
        
    }
}
