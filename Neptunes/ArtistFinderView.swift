//
//  ArtistFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-30.
//

import SwiftUI

struct ArtistFinderView: View {
    @State var searchText = ""
    var body: some View {
        NavigationView {
            Text("Hello, world!")
                .navigationBarTitle("Artists")
        }
        .searchable(text: $searchText)
    }
}

struct ArtistFinderView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistFinderView()
    }
}
