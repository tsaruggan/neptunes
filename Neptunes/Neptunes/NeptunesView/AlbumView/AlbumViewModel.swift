//
//  AlbumViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import Foundation
import CoreData
import SwiftUI

final class AlbumViewModel: ObservableObject {
    @Published var album: Album
    private var viewContext: NSManagedObjectContext? = nil

    init(album: Album, viewContext: NSManagedObjectContext) {
        self.album = album
    }
}
