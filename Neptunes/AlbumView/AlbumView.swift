//
//  AlbumView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-01.
//

import SwiftUI

struct AlbumView: View {
    @ObservedObject private var viewModel: AlbumViewModel = AlbumViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(album: Album) {
        self.viewModel.album = album
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.viewModel.setBackgroundColor()
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack(spacing: 0) {
                    StickyHeaderView(header: viewModel.album!.header)
                    Rectangle()
                        .ignoresSafeArea(.all)
                        .frame(minHeight: UIScreen.main.bounds.height - UIScreen.main.bounds.width / 3)
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(viewModel.backgroundColor ?? UIColor.red), .clear]),
                                                   startPoint: .top,
                                                   endPoint: .bottom))
                }
                
                VStack {
                    Image(viewModel.album!.image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .padding(.horizontal, 88)
                        .padding(.top, 100)
                        .padding(.bottom, 20)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewModel.album!.isSingle ? "Single" : "Album")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(viewModel.album!.title)
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.bottom, 4)
                        HStack {
                            Image(viewModel.album!.artist.image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(height: 28)
                            Text(viewModel.album!.artist.title)
                        }
                    }
                    .frame(width: 320, alignment: .leading)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.album!.songs.indices) { i in
                            SongView(song: viewModel.album!.songs[i], index: i+1)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 8)
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

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            NavigationView{
                AlbumView(album: MusicModel().albums[0])
            }
            .preferredColorScheme($0)
        }
        
    }
}
