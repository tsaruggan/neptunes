//
//  NeptunesView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-14.
//

import SwiftUI

struct NeptunesView<Content: View, Group: View>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var header: String?
    var backgroundColor: Color
    let content: Content
    let menu: Group
    init(header: String?, backgroundColor: Color, @ViewBuilder content: () -> Content, @ViewBuilder menu: () -> Group) {
        self.header = header
        self.backgroundColor = backgroundColor
        self.content = content()
        self.menu = menu()
        
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(header: header)
                    Spacer()
                }
                
                VStack {
                    content
                }
                .padding(.top, 100)
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .background(LinearGradient(colors: [backgroundColor, .clear], startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
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
