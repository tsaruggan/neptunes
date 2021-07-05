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
                
                if let header = album.header {
                    GeometryReader { g in
                        Image(header)
                            .resizable()
                            .scaledToFill()
                            .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
                            .frame(width: UIScreen.main.bounds.width,
                                   height: g.frame(in: .global).minY > 0 ?
                                   UIScreen.main.bounds.width / 3 + g.frame(in: .global).minY
                                   : UIScreen.main.bounds.width / 3)
                    }
                    .frame(height: UIScreen.main.bounds.width / 3, alignment: .center)
                }
    
                Group {
                    Image(album.image)
                        .resizable()
                        .scaledToFit()
                    Text(album.title)
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
                Menu {
                    Button(action: {}) {
                        Label("Import Music...", systemImage: "plus")
                    }
                    Button(action: {}) {
                        Label("Edit Album...", systemImage: "wand.and.stars")
                    }
                    Button(action: {}) {
                        Label("Share Album...", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                    }
                    .buttonStyle(ToolbarButtonStyle())
                }
                
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
            .foregroundColor(.primary)
            .background(Color.red.opacity(0.2), in: Circle())
            .background(.ultraThinMaterial, in: Circle())
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AlbumView(album: MusicModel().albums[2])
        }
    }
}



