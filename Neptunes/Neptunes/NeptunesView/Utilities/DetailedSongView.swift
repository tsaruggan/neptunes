//
//  DetailedSongView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import SwiftUI

struct DetailedSongView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var presentingSongEditor = false
    
    @EnvironmentObject var player: Player
    var song: Song
    var artistLabelColor: Color
    var foregroundColor: Color
    var explicitSignColor: Color
    var menuColor: Color
    var onTap: () -> Void
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            songInfo
            menuButton
        }
        .sheet(isPresented: $presentingSongEditor) {
            SongEditorView(
                viewModel: SongEditorViewModel(song: song, viewContext: viewContext),
                presentingEditor: $presentingSongEditor
            )
        }
    }
    
    var songInfo: some View {
        HStack(alignment: .center, spacing: 14) {
            Image(data: song.album.coverArtwork, fallback: "defaultcover")
                .resizable()
                .scaledToFit()
                .cornerRadius(4)
                .frame(height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 14) {
                    Text(song.title)
                        .fontWeight(.semibold)
                        .foregroundColor(foregroundColor)
                        .lineLimit(1)
                    if song.isExplicit {
                        Image(systemName: "e.square.fill")
                            .foregroundColor(explicitSignColor)
                    }
                }
                Text(song.artist.title)
                    .foregroundColor(artistLabelColor)
                    .font(.callout)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .onTapGesture {
            onTap()
        }
    }
    
    var menuButton: some View {
        Menu() {
            Button {
                player.addToNowPlaying(song: song)
            } label: {
                Label("Add To Now Playing", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Button {
                player.addToQueue(song: song)
            } label: {
                Label("Add To Queue", systemImage: "text.badge.plus")
            }
            Button {
                presentingSongEditor = true
            } label: {
                Label("Edit \(song.title)...", systemImage: "wand.and.stars")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(menuColor)
                .padding(.vertical, 8)
                .clipShape(Circle())
                .contentShape(Circle())
        }
    }
}
