//
//  SongView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import SwiftUI

struct SongView: View {
    var song: Song
    var index: Int
    var indexLabelColor: Color
    var foregroundColor: Color
    var explicitSignColor: Color
    var menuColor: Color
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Text(index < 10 ? String(format: "%2d", index) : String(index))
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
            Image(systemName: "ellipsis")
                .foregroundColor(menuColor)
        }
        .padding(12)
    }
}
