//
//  NeptunesView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-14.
//

import SwiftUI

struct NeptunesView<Content: View, MenuButtonGroup: View>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var headerURI: URL?
    var backgroundColor: Color
    let content: Content
    let menu: MenuButtonGroup
    
    init(headerURI: URL?, backgroundColor: Color, @ViewBuilder content: () -> Content, @ViewBuilder menu: () -> MenuButtonGroup) {
        self.headerURI = headerURI
        self.backgroundColor = backgroundColor
        self.content = content()
        self.menu = menu()
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(headerURI: headerURI)
                    Spacer()
                }
                
                VStack {
                    content
                }
                .padding(.top, 100)
                .padding(.bottom, 80)
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .background(LinearGradient(colors: [backgroundColor, .clear], startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading){ backButton }
            ToolbarItemGroup(placement: .navigationBarTrailing){ menuButton }
        }
        .buttonStyle(ToolbarButtonStyle(backgroundColor: backgroundColor))
    }
    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Label("Back", systemImage: "chevron.backward")
        }
    }
    
    var menuButton: some View {
        Menu() {
            menu
        } label: {
            Button(action: {}) { Image(systemName: "ellipsis") }
        }
    }
}

struct ToolbarButtonStyle: ButtonStyle {
    var backgroundColor: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        let width: CGFloat = 40
        configuration.label
            .frame(width: width, height: width)
            .buttonStyle(.bordered)
            .foregroundColor(.primary)
            .background(backgroundColor.opacity(0.3), in: Circle())
            .background(.ultraThinMaterial, in: Circle())
    }
}
