//
//  AlbumView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-01.
//

import SwiftUI

struct AlbumView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var album: Album
    
    init(album: Album) {
        self.album = album
        
        //        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "drake_album_art_1"), for: .default)
        
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
                        Label("Back", systemImage: "chevron.backward")
                    }
                    .accentColor(.white)
                    .buttonStyle(.bordered)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing){
                if #available(iOS 15.0, *) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accentColor(.white)
                    .buttonStyle(.bordered)
                    
                    
                    Button(action: {}) {
                        Image(systemName: "wand.and.stars")
                    }
                    .accentColor(.white)
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

