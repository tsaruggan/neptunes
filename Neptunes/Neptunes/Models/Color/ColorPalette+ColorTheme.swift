//
//  ColorPalette+ColorTheme.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-13.
//

import Foundation
import UIKit

typealias ColorTheme = (
    lightColor: UIColor,
    darkColor: UIColor
)

typealias ColorPalette = (
    primaryTheme: ColorTheme,
    secondaryTheme: ColorTheme,
    accentTheme: ColorTheme,
    backgroundTheme: ColorTheme
)


extension Palette {
    func toColorPalette() -> ColorPalette {
        let primaryTheme = (lightColor: UIColor(hex: self.primaryLight), darkColor: UIColor(hex: self.primaryDark))
        let secondaryTheme = (lightColor: UIColor(hex: self.secondaryLight), darkColor: UIColor(hex: self.secondaryDark))
        let accentTheme = (lightColor: UIColor(hex: self.accentLight), darkColor: UIColor(hex: self.accentDark))
        let backgroundTheme = (lightColor: UIColor(hex: self.backgroundLight), darkColor: UIColor(hex: self.backgroundDark))
        
        return ColorPalette(
            primaryTheme: primaryTheme,
            secondaryTheme: secondaryTheme,
            accentTheme: accentTheme,
            backgroundTheme: backgroundTheme
        )
    }
}


