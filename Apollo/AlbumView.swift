//
//  AlbumView.swift
//  Apollo
//
//  Created by Saruggan Thiruchelvan on 2021-07-01.
//

import SwiftUI

struct AlbumView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var album: Album
    
    init(album: Album) {
        self.album = album
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = .yellow
        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().backgroundColor = .black
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = .white
    }
    
    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading){
                if #available(iOS 15.0, *) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing){
                if #available(iOS 15.0, *) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                    
                    
                    Button(action: {}) {
                        Image(systemName: "wand.and.stars")
                    }
                    .buttonStyle(.bordered)
                }
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

