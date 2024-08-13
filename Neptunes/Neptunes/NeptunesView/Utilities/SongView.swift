//
//  SongView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import SwiftUI

struct SongView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var presentingSongEditor = false
    
    @EnvironmentObject var player: Player
    @ObservedObject var song: Song
    var index: Int
    var indexLabelColor: Color
    var foregroundColor: Color
    var explicitSignColor: Color
    var menuColor: Color
    var onTap: () -> Void
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            songInfo
            menuButton
        }
        .sheet(isPresented: $presentingSongEditor, onDismiss: {
            song.objectWillChange.send()  // Manually trigger a refresh
        }) {
            SongEditorView(
                viewModel: SongEditorViewModel(song: song, viewContext: viewContext),
                presentingEditor: $presentingSongEditor
            )
        }
    }
    
    var songInfo: some View {
        HStack(alignment: .center, spacing: 14) {
//                Text(index < 10 ? String(format: "%2d", index) : String(index))
            Text(String(index))
                .font(.system(.callout, design: .monospaced))
                .monospacedDigit()
                .foregroundColor(indexLabelColor)
            Text(song.title)
                .fontWeight(.medium)
                .foregroundColor(foregroundColor)
                .lineLimit(1)
            if song.isExplicit {
                Image(systemName: "e.square.fill")
                    .foregroundColor(explicitSignColor)
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
