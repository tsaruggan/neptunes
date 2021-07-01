//
//  AlbumView.swift
//  Apollo
//
//  Created by Saruggan Thiruchelvan on 2021-07-01.
//

import SwiftUI

struct AlbumView: View {
    var album: Album
    var body: some View {
        
        ZStack {
            ScrollView{
                Group {
                    Image(album.image)
                        .resizable()
                        .scaledToFit()
                    Text(album.album)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(50)
            }
        }
        .toolbar {
            Button {
                print("Edit mode activated!")
            } label: {
                Image(systemName: "wand.and.rays")
            }
        }
    }
    
    
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AlbumView(album: Album(album: "Days Before Rodeo", artist: "Travis Scott", image: "travis_scott_album_art_2"))
        }
    }
}
