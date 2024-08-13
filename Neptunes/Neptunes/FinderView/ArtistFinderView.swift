//
//  ArtistFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-12.
//

import SwiftUI
import CoreData

struct ArtistFinderView: View {
    @ObservedObject var viewModel: FinderViewModel<Artist>
    
    init(viewContext: NSManagedObjectContext) {
        self.viewModel = FinderViewModel<Artist>(entityName: "Artist", viewContext: viewContext)
    }
    
    var body: some View {
        FinderView(title: "Artists", findables: viewModel.findables) { findable in
            if let artist = findable as? Artist {
                ArtistFinderItemView(artist: artist)
            }
        }
    }
}

struct ArtistFinderItemView: View {
    @ObservedObject var artist: Artist
    var body: some View {
        NavigationLink {
            ArtistView(viewModel: .init(artist: artist))
        } label: {
            HStack(alignment: .center, spacing: 14) {
                HStack(alignment: .center, spacing: 14) {
                    Image(data: artist.coverArtwork, fallback: "defaultcover")
                        .resizable()
                        .scaledToFit()
                        .clipShape(.circle)
                        .frame(height: 40)
                    Text(artist.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
