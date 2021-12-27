//
//  EditorView.swift
//  EditorView
//
//  Created by Saruggan Thiruchelvan on 2021-09-25.
//

import SwiftUI

struct EditorView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @State var editing: Bool = true
    
    let title: String
    let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemGroupedBackground
        UINavigationBar.appearance().backgroundColor = .systemGroupedBackground
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(title)
                .environment(\.editMode, editing ? .constant(.active) : .constant(.inactive))
            
        }
//        .interactiveDismissDisabled(true)
        
    }
}

