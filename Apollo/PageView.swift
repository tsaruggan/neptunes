//
//  PageView.swift
//  Apollo
//
//  Created by Saruggan Thiruchelvan on 2021-06-26.
//

import SwiftUI

struct PageView: View {
    var text: String
    var body: some View {
        VStack {
            Spacer()
            Text(text)
            Spacer()
        }
        
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(text: "Hello, world!")
    }
}
