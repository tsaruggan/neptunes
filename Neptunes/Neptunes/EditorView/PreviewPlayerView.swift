//
//  PreviewPlayerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-02.
//

import SwiftUI

struct PreviewPlayerView: View {
    @ObservedObject public var viewModel: PreviewPlayerViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.togglePlay()
            } label: {
                Image(systemName: viewModel.isPlaying ? "stop.circle.fill" : "play.circle.fill")
            }
            ProgressView(value: viewModel.playbackProgress, total: 1.0)
                .progressViewStyle(.linear)
                .tint(.gray)
        }
    }
}
