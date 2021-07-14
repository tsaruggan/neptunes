//
//  Palette.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-12.
//

import Foundation
import SwiftUI

typealias ColorTheme = (light: Color, dark: Color?)

struct Palette {
    var primary: ColorTheme
    var secondary: ColorTheme
    var accent: ColorTheme
    var background: ColorTheme
    
    func primary(_ scheme: ColorScheme) -> Color { getColor(from: primary, for: scheme) }
    
    func secondary(_ scheme: ColorScheme) -> Color { getColor(from: secondary, for: scheme) }
    
    func accent(_ scheme: ColorScheme) -> Color { getColor(from: accent, for: scheme) }
    
    func background(_ scheme: ColorScheme) -> Color { getColor(from: background, for: scheme) }
    
    private func getColor(from theme: ColorTheme, for scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return theme.light
        case .dark:
            if let dark = theme.dark { return dark } else { fallthrough }
        @unknown default:
            return theme.light
        }
    }
}
