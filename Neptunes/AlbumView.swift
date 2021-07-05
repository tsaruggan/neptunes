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
            ZStack {
                VStack {
                    StickyHeaderView(header: album.header)
                    Spacer()
                }
                
                VStack {
                    Image(album.image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .padding(.horizontal, 88)
                        .padding(.top, 100)
                    Spacer()
                    VStack(alignment: .leading, spacing: 0) {
                        Text(album.isSingle ? "Single" : "Album")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(album.title)
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.bottom, 4)
                        HStack {
                            Image(album.artist.image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(height: 28)
                            Text(album.artist.title)
                        }
                    }
                    .frame(width: 320, alignment: .leading)
                    
                    VStack {
                        ForEach(album.songs.indices) { i in
                            HStack(spacing: 14) {
                                Text(i+1 < 10 ? String(format: "%2d ", i+1) : String(i+1))
                                    .monospacedDigit()
                                    .foregroundColor(.secondary)
                                Text(album.songs[i].title)
                                    .fontWeight(.medium)
                                if album.songs[i].isExplicit {
                                    Image(systemName: "e.square.fill")
                                        .foregroundColor(.red)
                                }
                                Spacer(minLength: 0)
                                Image(systemName: "ellipsis")
                            }
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius:8))

                        }
                    }
                    .padding(20)
                    Spacer()
                }
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
            }
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Menu() {
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
                    Button(action: {}) { Image(systemName: "ellipsis") }
                }
            }
        }
        .buttonStyle(ToolbarButtonStyle())
    }
}

struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        let width: CGFloat = 40
        configuration.label
            .frame(width: width, height: width)
            .buttonStyle(.bordered)
            .foregroundColor(.primary)
        //            .background(Color.red.opacity(0.2), in: Circle())
            .background(.ultraThinMaterial, in: Circle())
    }
}

struct StickyHeaderView: View {
    var header: String?
    var body: some View {
        if let header = header {
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
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AlbumView(album: MusicModel().albums[1])
        }
    }
}
