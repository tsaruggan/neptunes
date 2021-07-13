//
//  ColorAnalyzer.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-11.
//

import Foundation
import UIKit
import SwiftImage
import SwiftUI

class ColorAnalyzer {
    
    static func getPixelsFromImage(cgImage: CGImage, _ resizedWidth: Int, _ resizedHeight: Int) -> [Vector] {
        let image = SwiftImage.Image<RGBA<UInt8>>(cgImage: cgImage)
        let resizedImage = image.resizedTo(width: resizedWidth, height: resizedHeight, interpolatedBy: .nearestNeighbor)
        let pixels: [Vector] = resizedImage.map { pixel in
            Vector([pixel.redDouble, pixel.greenDouble, pixel.blueDouble])
        }
        return pixels
    }
    
    static func getColors(albumArt: String, headerArt: String, _ numColors: Int) -> [UIColor] {
        let albumImage: CGImage = UIImage(named: albumArt)!.cgImage!
        let headerImage: CGImage = UIImage(named: headerArt)!.cgImage!
        
        let pixels = getPixelsFromImage(cgImage: albumImage, 16, 16) + getPixelsFromImage(cgImage: headerImage, 24, 8)
        let kmm = KMeans(numColors)
        kmm.trainCenters(pixels, convergeDistance: 0.01)
        
        let colors = kmm.centroids.map { centroid in
            return UIColor(
                red: centroid.data[0] / 255.0,
                green: centroid.data[1] / 255.0,
                blue: centroid.data[2] / 255.0,
                alpha: 1.0
            )
        }
        let sortedColors = colors.sorted { $0.colorfulness > $1.colorfulness }
        return sortedColors
    }
    
    static func generatePalette(album: String, header: String) -> Palette {
        let colors: [UIColor] = getColors(albumArt: album, headerArt: header, 5)
        let backgroundColorLight = colors[0].lightenColor(.black)
        let backgroundColorDark = colors[0].darkenColor(.white)
        let primaryColorLight = colors[1].darkenColor(.white, backgroundColorLight)
        let primaryColorDark = colors[1].lightenColor(.black, backgroundColorDark)
        let secondaryColorLight = colors[2].darkenColor(.white, backgroundColorLight)
        let secondaryColorDark = colors[2].lightenColor(.black, backgroundColorDark)
        let tertiaryColorLight = colors[3].darkenColor(.white, backgroundColorLight)
        let tertiaryColorDark = colors[3].lightenColor(.black, backgroundColorDark)
        let accentColorLight = colors[4].darkenColor(.white, backgroundColorLight)
        let accentColorDark = colors[4].lightenColor(.black, backgroundColorDark)
        let palette = Palette(
            primary: (light: Color(primaryColorLight), dark: Color(primaryColorDark)),
            secondary: (light: Color(secondaryColorLight), dark: Color(secondaryColorDark)),
            tertiary: (light: Color(tertiaryColorLight), dark: Color(tertiaryColorDark)),
            accent: (light: Color(accentColorLight), dark: Color(accentColorDark)),
            background: (light: Color(backgroundColorLight), dark: Color(backgroundColorDark))
        )
        return palette
    }
    
    static func lightenColor(_ color: UIColor) -> UIColor {
        var contrast = color.contrastRatio(with: .black)
        var lightenedColor = color
        while (contrast < 3.00) {
            lightenedColor = lightenedColor.adjustBrightness(incrementBy: 0.05)
            contrast = lightenedColor.contrastRatio(with: .black)
        }
        return lightenedColor
    }
    
    static func darkenColor(_ color: UIColor) -> UIColor {
        var contrast = color.contrastRatio(with: .white)
        var darkenedColor = color
        while (contrast < 3.00) {
            darkenedColor = darkenedColor.adjustBrightness(incrementBy: -0.05)
            contrast = darkenedColor.contrastRatio(with: .white)
        }
        return darkenedColor
    }
}

extension RGBA where Channel == UInt8 {
    var redDouble: Double { return Double(red) }
    var greenDouble: Double { return Double(green) }
    var blueDouble: Double { return Double(blue) }
    var alphaDouble: Double { return Double(alpha) }
}

extension UIColor {
    var luminance: CGFloat {
        let ciColor = CIColor(color: self)
        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * adjust(colorComponent: ciColor.red) + 0.7152 * adjust(colorComponent: ciColor.green) + 0.0722 * adjust(colorComponent: ciColor.blue)
    }
    
    var colorfulness: CGFloat {
        var red: CGFloat        = 0.0
        var green: CGFloat      = 0.0
        var blue: CGFloat       = 0.0
        var alpha: CGFloat      = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rg = abs(red - green)
        let yb = abs(0.5 * (red + green) - blue)
        let root = (pow(rg, 2) + pow(yb, 2)).squareRoot()
        return root * 0.3
    }
    
    func contrastRatio(with color: UIColor) -> CGFloat {
        let luminance1 = self.luminance
        let luminance2 = color.luminance
        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)
        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }
    
    func adjustBrightness(incrementBy increment: CGFloat) -> UIColor {
        var hue: CGFloat        = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat      = 0.0
        
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newColor = UIColor( hue: hue, saturation: saturation, brightness: brightness + increment, alpha: alpha)
        return newColor
    }
    
    func lightenColor(_ contrastWith: UIColor...) -> UIColor {
//        var contrast: CGFloat = contrastWith.reduce(3.00, { min($0, self.contrastRatio(with: $1)) })
        var contrast = self.contrastRatio(with: .black)
        var lightenedColor = self
        while (contrast < 3.00) {
            lightenedColor = lightenedColor.adjustBrightness(incrementBy: 0.05)
//            contrast = contrastWith.reduce(contrast, { min($0, lightenedColor.contrastRatio(with: $1)) })
            contrast = lightenedColor.contrastRatio(with: .black)
        }
        return lightenedColor
    }
    
    func darkenColor(_ contrastWith: UIColor...) -> UIColor {
//        var contrast: CGFloat = contrastWith.reduce(3.00, { min($0, self.contrastRatio(with: $1)) })
        var contrast = self.contrastRatio(with: .white)
        var darkenedColor = self
        while (contrast < 3.00) {
            darkenedColor = darkenedColor.adjustBrightness(incrementBy: -0.05)
//            contrast = contrastWith.reduce(contrast, { min($0, darkenedColor.contrastRatio(with: $1)) })
            contrast = darkenedColor.contrastRatio(with: .white)
        }
        return darkenedColor
    }
}
