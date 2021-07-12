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
    @Environment(\.colorScheme) var colorScheme
    
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
                    SongListView(
                        songs: viewModel.album.songs,
                        indexLabelColor: colorScheme == .dark ? viewModel.palette.secondaryDark : viewModel.palette.secondaryLight,
                        foregroundColor: colorScheme == .dark ? viewModel.palette.primaryDark : viewModel.palette.primaryLight,
                        explicitSignColor: colorScheme == .dark ? viewModel.palette.accentDark : viewModel.palette.accentLight,
                        menuColor: colorScheme == .dark ? viewModel.palette.tertiaryDark : viewModel.palette.tertiaryLight
                    )
                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .background(background)
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading){ backButton }
            ToolbarItemGroup(placement: .navigationBarTrailing){ menuButton }
        }
        .buttonStyle(ToolbarButtonStyle(backgroundColor: colorScheme == .dark ? viewModel.palette.tertiaryDark : viewModel.palette.tertiaryLight,
                                        foregroundColor: colorScheme == .dark ? viewModel.palette.primaryDark : viewModel.palette.primaryLight))
    }
        
    var background: some View {
        LinearGradient(colors: [colorScheme == .dark ? viewModel.palette.backgroundDark : viewModel.palette.backgroundLight, .clear],
                       startPoint: .top,
                       endPoint: .bottom)
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
                .foregroundColor(colorScheme == .dark ? viewModel.palette.secondaryDark : viewModel.palette.secondaryLight)
            Text(viewModel.album.title)
                .foregroundColor(colorScheme == .dark ? viewModel.palette.primaryDark : viewModel.palette.primaryLight)
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
                    .foregroundColor(colorScheme == .dark ? viewModel.palette.primaryDark : viewModel.palette.primaryLight)
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
    var backgroundColor: Color
    var foregroundColor: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        let width: CGFloat = 40
        configuration.label
            .frame(width: width, height: width)
            .buttonStyle(.bordered)
            .foregroundColor(foregroundColor)
            .background(backgroundColor.opacity(0.1), in: Circle())
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
