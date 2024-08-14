//
//  ArtistEditorView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-13.
//

import SwiftUI
import PhotosUI
import AVFoundation
import Mantis

struct ArtistEditorView: View {
    
    @ObservedObject public var viewModel: ArtistEditorViewModel
    
    @Binding var presentingEditor: Bool
    
    @State private var selectedArtistCoverArtworkPhotosPickerItem: PhotosPickerItem? = nil
    @State private var selectedArtistHeaderArtworkPhotosPickerItem: PhotosPickerItem? = nil
    
    init(viewModel: ArtistEditorViewModel, presentingEditor: Binding<Bool>) {
        self.viewModel = viewModel
        self._presentingEditor = presentingEditor
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
    
    func getTitle(_ editorAction: EditorActionType) -> String {
        return "Edit Artist"
    }
    
    var body: some View {
        NavigationView {
            Form {
                artistInformation
            }
            .navigationTitle(getTitle(viewModel.editorAction))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        presentingEditor = false
                    }
                    .foregroundColor(.red)
                    
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        viewModel.updateArtist()
                        presentingEditor = false
                    }
                    .disabled(!viewModel.validate())
                }
            }
            .interactiveDismissDisabled()
        }
    }
    
    var artistInformation: some View {
        Section("Artist Information") {
            TextField("Title", text: $viewModel.artistTitle)
            artistCoverArtworkPicker
            artistHeaderArtworkPicker
        }
    }
    
    var artistCoverArtworkPicker: some View {
        InitializedDisclosureGroup(isExpanded: true) {
            PhotoPickerView(image: $viewModel.artistCoverArtwork,
                            type: .artist,
                            onChange: viewModel.onArtistArtworkChange)
        } label: {
            Text("Artwork")
        }
    }
    
    var artistHeaderArtworkPicker: some View {
        InitializedDisclosureGroup(isExpanded: true) {
            PhotoPickerView(image: $viewModel.artistHeaderArtwork,
                            type: .header,
                            onChange: viewModel.onArtistArtworkChange)
        } label: {
            Text("Header")
        }
    }
}
