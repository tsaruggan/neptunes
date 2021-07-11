//
//  AlbumView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-01.
//

import SwiftUI

struct AlbumView: View {
    @ObservedObject private var viewModel: AlbumViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack(spacing: 0) {
                    StickyHeaderView(header: viewModel.album.header)
                    Spacer()
                }
                
                VStack {
                    albumArt
                    albumInformation
                    SongListView(songs: viewModel.album.songs)
                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading){ backButton }
            ToolbarItemGroup(placement: .navigationBarTrailing){ menuButton }
        }
        .buttonStyle(ToolbarButtonStyle())
    }
    
    var albumArt: some View {
        Image(viewModel.album.image)
            .resizable()
            .scaledToFit()
            .cornerRadius(8)
            .padding(.horizontal, 88)
            .padding(.top, 100)
            .padding(.bottom, 20)
    }
    
    var albumInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.album.isSingle ? "Single" : "Album")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(viewModel.album.title)
                .fontWeight(.bold)
                .font(.title)
                .padding(.bottom, 4)
            HStack {
                Image(viewModel.album.artist.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(height: 28)
                Text(viewModel.album.artist.title)
            }
        }
        .frame(width: 320, alignment: .leading)
    }
    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Label("Back", systemImage: "chevron.backward")
        }
    }
    
    var menuButton: some View {
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

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            NavigationView{
                AlbumView(viewModel: .init(album: MusicModel().albums[0]))
            }
            .preferredColorScheme($0)
        }
        
    }
}
