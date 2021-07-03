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
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                GeometryReader { g in
                    Image(album.header)
                        .resizable()
                        .scaledToFill()
                        .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
                        .frame(width: UIScreen.main.bounds.width,
                               height: g.frame(in: .global).minY > 0 ?
                               UIScreen.main.bounds.width / 3 + g.frame(in: .global).minY
                               : UIScreen.main.bounds.width / 3)
                }
                .frame(height: UIScreen.main.bounds.width / 3, alignment: .center)
                
                Group {
                    Image(album.image)
                        .resizable()
                        .scaledToFit()
                    Text(album.album)
                }
                .padding(50)
                
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading){
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.backward")
                }
                .buttonStyle(ToolbarButtonStyle())
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Button(action: {}) {
                    Image(systemName: "plus")
                }
                .buttonStyle(ToolbarButtonStyle())
                
                Button(action: {}) {
                    Image(systemName: "wand.and.stars")
                }
                .buttonStyle(ToolbarButtonStyle())
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(ToolbarButtonStyle())
            }
        }
    }
}

struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        let width: CGFloat = 40
        configuration.label
            .frame(width: width, height: width)
            .buttonStyle(.bordered)
            .foregroundColor(.teal)
            .background(.thinMaterial)
            .clipShape(Circle())
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AlbumView(album: Album(album: "Days Before Rodeo", artist: "Travis Scott", image: "travis_scott_album_art_2", header: "travis_scott_header_art"))
        }
    }
}



