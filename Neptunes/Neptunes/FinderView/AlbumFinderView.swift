//
//  AlbumFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-12.
//

import SwiftUI
import CoreData

struct AlbumFinderView: View {
    @ObservedObject var viewModel: FinderViewModel<Album>
    
    init(viewContext: NSManagedObjectContext) {
        self.viewModel = FinderViewModel<Album>(entityName: "Album", viewContext: viewContext)
    }
    
    var body: some View {
        FinderView(title: "Albums", findables: viewModel.findables) { findable in
            if let album = findable as? Album {
                AlbumFinderItemView(album: album)
            }
        }
    }
}

struct AlbumFinderItemView: View {
    var album: Album
    var body: some View {
        NavigationLink {
            AlbumView(viewModel: .init(album: album))
        } label: {
            HStack(alignment: .center, spacing: 14) {
                HStack(alignment: .center, spacing: 14) {
                    Image(data: album.coverArtwork, fallback: "defaultcover")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4)
                        .frame(height: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(album.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        Text(album.artist.title)
                            .foregroundColor(.secondary)
                            .font(.callout)
                            .lineLimit(1)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
